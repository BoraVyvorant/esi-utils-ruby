# frozen_string_literal: true

require 'esi-client-bvv'

module ESIUtils
  #
  # ESIUtils::Client
  #
  # API client that extends call_api to look for API warnings.
  #
  class ESIClient < ESI::ApiClient
    def initialize
      super
      @seen_warnings = Set.new
      @delay_times = [0, 0.5, 1, 2, 5, 15].freeze
    end

    #
    # Shorthand access to the base API client's configured
    # logger.
    #
    def logger
      @config.logger
    end

    #
    # Log deprecation warnings, as they indicate that we need to upgrade
    # to a new version of the route.
    #
    def log_warning_header(path, headers)
      return unless (warning = headers['Warning'])

      # Don't warn just because a new route is available.
      return if warning.start_with? '199'

      # Genericise the path, removing parameters
      g_path = path.gsub(%r{/\d+/}, '/id/')

      # Only notify about a given (genericised) path once
      return if @seen_warnings.include?(g_path)
      @seen_warnings.add(g_path)

      logger.warn "'#{warning}' on path '#{g_path}'"
    end

    #
    # Does the given HTTP status code represent something
    # that we should retry?
    #
    # 420 Error Limited
    # 502 Bad Gateway
    # 503 Service Unavailable
    # 504 Gateway Timeout
    #
    def retry_status?(code)
      case code
      when 420, 502, 503, 504
        true
      else
        false
      end
    end

    #
    # Can we retry?
    #
    # Based on the details of the APIError exception along
    # with an array of remaining retry delays.
    #
    # If retrying is possible, the result is a number of seconds
    # to delay before performing the next attempt.
    #
    def can_retry?(api_error, delays)
      # Can't retry if we have exhausted our list of retry delays.
      return false if delays.empty?
      # Only certain status codes are retryable.
      return false unless retry_status?(api_error.code)
      # Peel off a time to delay for before retrying.
      delays.shift
    end

    #
    # Customised call_api, which wraps itself around the one
    # provided by the Swagger generated code.
    #
    # Adds:
    #
    # * Logging of warning headers when the API is versioned.
    # * Automatic retrying of temporary failures.
    #
    def call_api(http_method, path, opts = {})
      delays = @delay_times.dup
      begin
        data, code, headers = super(http_method, path, opts)
        log_warning_header(path, headers)
        [data, code, headers]
      rescue ESI::ApiError => api_error
        raise unless (secs = can_retry?(api_error, delays))
        logger.info "retrying #{http_method} on '#{path}' after #{secs}s"
        sleep(secs)
        retry
      end
    end
  end
end
