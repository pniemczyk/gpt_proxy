# frozen_string_literal: true

json.error do
  json.message error.message
  json.status status
  json.original_body error.body
  json.original_error error.original_error
end

json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
  json.provider provider.name
end
