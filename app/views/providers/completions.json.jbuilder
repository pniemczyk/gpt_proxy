# frozen_string_literal: true

json.merge! result.body
json.proxy do
  json.profile result.profile
  json.status result.metadata.dig(:response, :status)
  json.original_body result.metadata.dig(:response, :body)
end
json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
  json.provider provider.name
end
