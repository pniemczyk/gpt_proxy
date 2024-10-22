# frozen_string_literal: true

json.providers do
  json.array! providers, partial: 'providers/provider', as: :provider
end

json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
end
