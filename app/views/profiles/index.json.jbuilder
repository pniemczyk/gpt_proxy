# frozen_string_literal: true

json.profiles do
  json.array! profiles, partial: 'profiles/profile', as: :profile
end

json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.current_url request.url
end
