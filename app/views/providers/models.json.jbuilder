# frozen_string_literal: true

# json.models list
json.merge! result.body
if result.respond_to?(:metadata)
  json.proxy do
    json.status result.metadata.dig(:response, :status)
    json.original_body result.metadata.dig(:response, :body)
  end
end
json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
  json.provider provider.name
end
