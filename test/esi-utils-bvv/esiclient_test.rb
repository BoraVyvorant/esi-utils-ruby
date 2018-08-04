# frozen_string_literal: true

require 'esi-client-bvv'
require 'esi-utils-bvv'
require 'minitest/autorun'

class TestESIClient < Minitest::Test
  def setup
    @client = ESIUtils::ESIClient.new
  end

  def test_creation
    refute_nil @client
  end

  def test_retry_status
    refute @client.retry_status?(nil)
    refute @client.retry_status?(0)
    refute @client.retry_status?(200)

    assert @client.retry_status?(420)
    assert @client.retry_status?(502)
    assert @client.retry_status?(503)
    assert @client.retry_status?(504)
  end

  def test_can_retry
    [420, 502, 503, 504].each do |code|
      delays = [1, 2, 3]
      exception = ESI::ApiError.new(code: code)
      can = @client.can_retry?(exception, delays)
      assert can, "code #{code}"
      assert can == 1, "code #{code}"
      assert delays == [2, 3], "code #{code}"
    end
  end

  def test_strip_delay
    exception502 = ESI::ApiError.new(code: 502)
    delays = [1]
    # first time through should peel off the first delay
    assert @client.can_retry?(exception502, delays) == 1
    assert delays == []
    # second time through should be false, no delays left
    refute @client.can_retry?(exception502, delays)
  end
end
