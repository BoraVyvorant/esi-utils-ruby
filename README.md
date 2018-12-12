# `esi-utils-ruby`

This project is the Ruby gem `esi-utils-bvv`, containing
ESI utility classes for use with the `esi-client-bvv` gem.

## Release Process

Here is a reminder for how to release this gem:

* Change the version string in `lib/esi-utils-bvv/version.rb`.
* `bundle exec rake build`
* Commit the version file, the `Gemfile.lock` and anything else that
  is outstanding.
* `bundle exec rake release`
