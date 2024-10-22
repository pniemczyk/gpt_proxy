# frozen_string_literal: true

json.extract! provider, :id, :name, :api_key, :url, :chat_path, :models_path, :default_model, :info, :models, :payload_options, :headers_options, :profilable, :created_at, :updated_at # rubocop:disable Layout/LineLength
json.proxy_url provider_url(provider, format: :json)
