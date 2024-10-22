# frozen_string_literal: true

class Provider::Copilot
  include ProviderConfiguration
  include FaradayClient

  def self.ask(content, profile: nil, model: default_model, options: {})
    system = profile_content(profile)
    messages = [ ({ role: 'system', content: system } if system), { role: 'user', content: } ].compact
    response = chat(payload_merge(options, model:, messages:))
    body = Hashie::Mash.new(
      ref_id: response.body.id,
      answer: response.body.choices.first.message&.content
    )
    result(body:, response:, profile: system ? profile : nil).tap { |res| yield(res) if block_given? }
  end

  def self.completions(payload, profile: nil, options: {})
    current_payload = hashify(payload)

    system = profile_content(profile)
    if system
      system_message = current_payload[:messages].find { |m| m[:role] == 'system' }
      system_message ? system_message[:content] = system : current_payload[:messages].unshift({ role: 'system', content: system })
    end

    current_payload[:model] = default_model unless current_payload[:model]
    response = chat(payload_merge(options, current_payload))
    body = Hashie::Mash.new(
      ref_id: response.body.id,
      message: response.body.choices.first.message,
      model: current_payload[:model],
      finish_reason: response.body.choices.first.finish_reason
    )
    result(body:, response:, profile: system ? profile : nil).tap { |res| yield(res) if block_given? }
  end

  def self.chat(payload) = handle { client.post(chat_path, payload) }.tap { |res| yield(res) if block_given? }
  def self.client = build_client(url:, api_key:, headers_options:)
  def self.auth = { method: :headers, key: 'Authorization', type: 'Bearer' }
  def self.models = raise NoMethodError
  def self.models_names = raise NoMethodError
end
