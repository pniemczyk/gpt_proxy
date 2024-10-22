# frozen_string_literal: true

json.provider do
  json.partial! 'providers/provider', locals: { provider: }
end

json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
end
