# frozen_string_literal: true

module Faraday
  class Capture < ::Faraday::Middleware
    def self.capture(&block)
      current = @capture
      @capture = true
      block.call
    ensure
      @capture = current
    end

    def self.capture? = @capture ||= ActiveModel::Type::Boolean.new.cast(ENV['FARADAY_CAPTURE'])
    def self.publish? = @publish ||= ActiveModel::Type::Boolean.new.cast(ENV['FARADAY_PUBLISH'])

    def call(env)
      @env = env
      request = process_capture_request(env)
      @app.call(env).on_complete { |response| process_capture(request, response) }
    end

    private

    def process_capture_request(env)
      parse_request(env).tap do |request|
        return unless self.class.publish?

        ActiveSupport::Notifications.instrument('faraday.capture_request', request:)
        return unless self.class.capture?

        request.id = Captured::Request.create(request)&.id
      end
    end

    def parse_request(env)
      {
        ref_id: SecureRandom.uuid,
        method: env.method,
        url: env.url.to_s,
        headers: env.request_headers,
        body: env.body
      }
    end

    def process_capture(request, response)
      parse_response(response).tap do |response|
        return unless self.class.publish?

        ActiveSupport::Notifications.instrument('faraday.capture', capture: { id: request.ref_id, request:, response: })
        return unless self.class.capture?

        Captured::Response.create(response.merge(request_id: request.id))
      end
    end

    def parse_response(response)
      {
        status: response.status,
        headers: response.response_headers,
        body: response.body
      }
    end
  end
end

::Faraday::Middleware.register_middleware capture: -> { Faraday::Capture }
