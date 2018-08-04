# frozen_string_literal: true

require 'esi-utils-bvv'
require 'minitest/autorun'

class TestESIClient < Minitest::Test
  def test_creation
    client = ESIUtils::ESIClient.new
    refute_nil client
  end
end
