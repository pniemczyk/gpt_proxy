# frozen_string_literal: true

class Provider::Gemini
  include ProviderConfiguration
  include FaradayClient

  def self.ask(text, profile: nil, model: default_model, options: {})
    contents = [ { role: 'user', parts: [ { text: } ] } ]
    response = chat(payload_merge(options, contents:), model:)
    body = Hashie::Mash.new(
      ref_id: nil,
      answer: response.body.candidates.first&.content&.parts&.first&.text
    )
    result(body:, response:, profile:).tap { |res| yield(res) if block_given? }
  end

  def self.completions(payload, profile: nil, options: {})
    current_payload = hashify(payload)

    contents = current_payload[:messages].map { |m| { role: m[:role] == 'assistant' ? 'model' : m[:role], parts: [ { text: m[:content] } ] } }
    model = current_payload[:model] || default_model

    response = chat(payload_merge(options, contents:), model:)
    candidate = response.body.candidates.first
    body = Hashie::Mash.new(
      ref_id: nil,
      message: {
        role: candidate.content.role == 'model' ? 'assistant' : 'user',
        content: candidate.content.parts.first.text
      },
      model:,
      finish_reason: candidate.finishReason&.downcase
    )
    result(body:, response:, profile:).tap { |res| yield(res) if block_given? }
  end

  def self.model_names
    response = handle { client.get(models_path) }.tap { |res| yield(res) if block_given? }
    result(body: { models: response.body.models.map { |m| m.name.gsub(/^models\//, '') } }, response:)
  end

  def self.chat(payload, model: default_model) = handle { client.post("#{chat_path}/#{model}:generateContent", payload) }.tap { |res| yield(res) if block_given? }
  def self.models = handle { client.get(models_path) }.body.models
  def self.client = build_client(url:, params: { key: api_key }, headers_options:)
  def self.auth = { method: :params, key: :key, type: :plain }
end
