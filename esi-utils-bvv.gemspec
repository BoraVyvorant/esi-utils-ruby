# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esi-utils-bvv/version'

Gem::Specification.new do |s|
  s.name        = 'esi-utils-bvv'
  s.version     = ESIUtils::VERSION
  s.authors     = ['Bora Vyvorant']
  s.email       = ['bora.vyvorant@gmail.com']

  s.summary     = 'ESI utility classes to partner with esi-client-bvv.'
  s.homepage    = 'https://github.com/BoraVyvorant/esi-client-ruby/'

  s.license     = 'Apache-2.0'
  s.required_ruby_version = '>= 2.4'

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.14'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rubocop'

  s.add_dependency 'esi-client-bvv', '~> 1.0.4'

  #
  # Pin the 'ffi' gem at version 1.9.21 to prevent segfaults on
  # macOS 10.13 High Sierra.
  #
  # Underlying issue: https://github.com/ffi/ffi/issues/619
  #
  # This gem is an indirect dependency via
  #  esi-client-bvv --> typhoeus --> ethon --> ffi
  # but ethon requires only >= 1.3.0.
  #
  s.add_dependency 'ffi', '1.9.21'
end
