# frozen_string_literal: true

# test/support/vcr_setup.rb
require 'vcr'
require 'webmock/minitest'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  # config.ignore_localhost = true
  config.ignore_request do |request|
    # Ollama provider uses localhost:11434
    URI(request.uri).host == 'localhost' && URI(request.uri).port != 11434
  end
end

module VcrTestHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def vcr_test(name, cassette: nil, &block)
      cassette_name = cassette || "#{self.name.underscore}_#{name.underscore}".gsub(/\W+/, '_')
      test name do
        VCR.use_cassette(cassette_name) do
          instance_exec(&block)
        end
      end
    end
  end
end
