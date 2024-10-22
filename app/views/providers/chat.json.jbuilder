# frozen_string_literal: true

json.merge! result.body
json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.url request.url
  json.provider provider.name
end
