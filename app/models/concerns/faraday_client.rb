# frozen_string_literal: true

module FaradayClient
  class ErrorResponse < StandardError
    attr_reader :status, :body, :info, :original_error

    def initialize(status, body = nil, error = nil)
      @status = status || 500
      @body = body
      @original_error = error
      @info = Rack::Utils::HTTP_STATUS_CODES[status].to_s.humanize rescue 'Unknown status'
      super("Client Error: #{error.present? ? "#{error.class}: #{error.message}" : "#{info} (#{status})"}")
    end
  end

  extend ActiveSupport::Concern

  included do
    def self.build_client(url:, params: {}, api_key: nil, headers_options: {})
      Faraday.new(url:, params:) do |faraday|
        headers_options.each { |key, value| faraday.headers[key] = value }
        faraday.request :authorization, 'Bearer', api_key if api_key.present?
        faraday.request :json
        faraday.response :mashify
        faraday.response :json
        faraday.use :capture
        faraday.adapter Faraday.default_adapter
      end
    end

    def self.handle(&block)
      block.call
           .tap { |r| raise FaradayClient::ErrorResponse.new(r.status, r.body) unless r.status == 200 }
    rescue => e
      raise FaradayClient::ErrorResponse.new(nil, nil, e) unless e.is_a?(FaradayClient::ErrorResponse)
      raise e
    end
  end
end
