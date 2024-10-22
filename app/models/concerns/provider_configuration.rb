# frozen_string_literal: true

module ProviderConfiguration
  extend ActiveSupport::Concern

  class Result
    include ActiveModel::Model
    attr_accessor :body, :metadata, :response, :profile
    def metadata = (@metadata ||= {}).merge(response: { status: response.status, body: response.body.deep_symbolize_keys })
    def as_json = { body:, metadata:, profile: }
  end

  included do
    class_attribute :config
    self.config = Provider.find_by!(id: name.demodulize.underscore)

    singleton_class.class_eval do
      def hashify(hash) = (hash.presence || {}).deep_symbolize_keys
      def payload_options = hashify(config.payload_options)
      def headers_options = hashify(config.headers_options)
      def payload_merge(*options) = payload_options.deep_merge(Array(options).map(&method(:hashify)).reduce(:deep_merge))
      def result(**args) = Result.new(**args)
      def profile_content(id)
        return nil unless profilable

        Profile.find_by(id:).then { |pr| (pr&.providers.presence || []).include?(config.id) ? pr.content : nil }
      end

      delegate :url, :api_key, :chat_path, :models_path, :default_model, :profilable, to: :config
    end
  end
end
