# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    id { 'open_ai' }
    name { 'OpenAI' }
    url { 'https://api.openai.com/v1' }
    chat_path { 'chat/completions' }
    models_path { 'models' }
    api_key { 'sk-proj-QhR' }
    default_model { 'gpt-3.5-turbo' }
    models { %w[gpt-4-turbo gpt-4-turbo-2024-04-09 chatgpt-4o-latest gpt-4-turbo-preview gpt-4o-2024-08-06 gpt-3.5-turbo-instruct gpt-4o gpt-4-0125-preview gpt-3.5-turbo-0125 gpt-3.5-turbo gpt-4o-realtime-preview-2024-10-01 gpt-4o-realtime-preview gpt-4-1106-preview gpt-3.5-turbo-16k gpt-3.5-turbo-1106 gpt-4-0613 gpt-4 gpt-3.5-turbo-instruct-0914 gpt-4o-mini gpt-4o-2024-05-13 gpt-4o-mini-2024-07-18] }
    profilable { true }
    payload_options { { max_tokens: 1024, temperature: 0.7 } }
    headers_options { nil }
    info do
      {
        homepage: 'https://www.openai.com/',
        documentation: 'https://beta.openai.com/docs/',
        models: 'https://platform.openai.com/docs/models',
        key_generation: 'https://platform.openai.com/api-keys'
      }
    end

    factory :open_ai_provider do
      id { 'open_ai' }
    end

    factory :ollama_provider do
      id { 'ollama' }
      name { 'Ollama' }
      url { 'http://localhost:11434' }
      chat_path { 'api/chat' }
      models { %w[llama3.2 llama3.2:1b llama3.1 llama3.1:70b llama3.1:405b phi3 phi3:medium gemma2:2b gemma2 gemma2:27b mistral moondream neural-chat starling-lm codellama llama2-uncensored llava solar] }
      default_model { 'llama3.1:70b' }
      payload_options { { stream: false } }
      info do
        {
          homepage: 'https://ollama.com/',
          documentation: 'https://github.com/ollama/ollama',
          models: 'https://ollama.com/library',
          github: 'https://github.com/ollama/ollama'
        }
      end
    end

    factory :groq_provider do
      id { 'groq' }
      name { 'Groq' }
      api_key { 'gsk_QIZ' }
      url { 'https://api.groq.com/openai/v1' }
      chat_path { 'chat/completions' }
      models_path { 'models' }
      models { %w[llama3-groq-70b-8192-tool-use-preview llama-3.2-11b-text-preview llama3-70b-8192 llama-3.1-70b-versatile llama-3.2-11b-vision-preview whisper-large-v3 llama-guard-3-8b llava-v1.5-7b-4096-preview gemma2-9b-it whisper-large-v3-turbo llama3-8b-8192 llama-3.2-3b-preview distil-whisper-large-v3-en mixtral-8x7b-32768 llama-3.2-90b-text-preview gemma-7b-it llama3-groq-8b-8192-tool-use-preview llama-3.2-1b-preview llama-3.1-8b-instant] }
      default_model { 'llama3-8b-8192' }
      payload_options { { max_tokens: 1024, temperature: 0.7 } }
      info do
        {
          homepage: 'https://www.groq.com/',
          documentation: 'https://console.groq.com/docs/api-reference#chat-create',
          models: 'https://console.groq.com/docs/models',
          key_generation: 'https://console.groq.com/keys'
        }
      end
    end

    factory :gemini_provider do
      id { 'gemini' }
      name { 'Gemini' }
      api_key { 'AIzaS' }
      url { 'https://generativelanguage.googleapis.com/v1beta' }
      chat_path { 'models' }
      models_path { 'models' }
      models { %w[chat-bison-001 text-bison-001 embedding-gecko-001 gemini-1.0-pro-latest gemini-1.0-pro gemini-pro gemini-1.0-pro-001 gemini-1.0-pro-vision-latest gemini-pro-vision gemini-1.5-pro-latest gemini-1.5-pro-001 gemini-1.5-pro-002 gemini-1.5-pro gemini-1.5-pro-exp-0801 gemini-1.5-pro-exp-0827 gemini-1.5-flash-latest gemini-1.5-flash-001 gemini-1.5-flash-001-tuning gemini-1.5-flash gemini-1.5-flash-exp-0827 gemini-1.5-flash-002 gemini-1.5-flash-8b gemini-1.5-flash-8b-001 gemini-1.5-flash-8b-latest gemini-1.5-flash-8b-exp-0827 gemini-1.5-flash-8b-exp-0924 embedding-001 text-embedding-004 aqa] }
      default_model { 'gemini-1.5-flash-latest' }
      profilable { false }
      payload_options { {} }
      headers_options { {} }
      info do
        {
          homepage: 'https://ai.google.dev/gemini-api',
          documentation: 'https://ai.google.dev/gemini-api/docs',
          models: 'https://ai.google.dev/gemini-api/docs/models/gemini',
          key_generation: 'https://aistudio.google.com/app/apikey'
        }
      end
    end

    factory :anthropic_provider do
      id { 'anthropic' }
      name { 'Anthropic' }
      api_key { 'sk-ant-api' }
      url { 'https://api.anthropic.com/v1' }
      chat_path { 'messages' }
      models { %w[claude-3-5-sonnet-20240620 claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307] }
      default_model { 'claude-3-5-sonnet-20240620' }
      profilable { true }
      payload_options { { max_tokens: 1024 } }
      headers_options { { 'anthropic-version' => '2023-06-01' } }
      info do
        {
          homepage: 'https://www.anthropic.com/',
          documentation: 'https://docs.anthropic.com/en/api/getting-started',
          models: 'https://docs.anthropic.com/en/docs/about-claude/models#model-names',
          key_generation: 'https://console.anthropic.com/settings/keys'
        }
      end
    end
  end
end

# == Schema Information
#
# Table name: providers
#
#  id              :string           not null, primary key
#  api_key         :string
#  chat_path       :string
#  default_model   :string
#  headers_options :text
#  info            :text
#  models          :text
#  models_path     :string
#  name            :string
#  payload_options :text
#  profilable      :boolean
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
