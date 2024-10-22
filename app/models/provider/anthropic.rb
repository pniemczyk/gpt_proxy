# frozen_string_literal: true

class Provider::Anthropic
  include ProviderConfiguration
  include FaradayClient

  STOP_REASON_MAP = {
    'end_turn' => 'stop',
    'max_tokens' => 'length'
    # 'stop_sequence' => 'stop',
    # 'tool_use' => 'stop'
  }.freeze

  def self.ask(content, profile: nil, model: default_model, options: {})
    payload = { model:, messages: [ { role: 'user', content: content } ] }
    system = profile_content(profile)
    payload[:system] = system if system
    response = chat(payload_merge(options, payload))
    body = Hashie::Mash.new(
      ref_id: response.body.id,
      answer: response.body.content.first&.text
    )
    result(body:, response:, profile: system ? profile : nil).tap { |res| yield(res) if block_given? }
  end

  def self.completions(payload, profile: nil, options: {})
    current_payload = hashify(payload)
    system = profile_content(profile)
    current_payload[:system] = system if system
    current_payload[:model] = default_model unless current_payload[:model]
    response = chat(payload_merge(options, current_payload))
    finish_reason = response.body.stop_reason&.downcase
    body = Hashie::Mash.new(
      message: {
        role: response.body.role,
        content: response.body.content.first.text
      },
      ref_id: response.body.id,
      model: current_payload[:model],
      finish_reason: STOP_REASON_MAP[finish_reason] || 'stop'
    )
    result(body:, response:, profile: system ? profile : nil).tap { |res| yield(res) if block_given? }
  end

  def self.chat(payload) = handle { client.post(chat_path, payload) }.tap { |res| yield(res) if block_given? }
  def self.client = build_client(url:, headers_options: headers_options.merge('x-api-key' => api_key))
  def self.auth = { method: :headers, key: 'x-api-key', type: :plain }
  def self.models = raise NoMethodError
  def self.models_names = raise NoMethodError
end
