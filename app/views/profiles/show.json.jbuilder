# frozen_string_literal: true

json.profile do
  json.partial! 'profiles/profile', locals: { profile: }
end

json.info do
  json.app Rails.application.class.module_parent_name
  json.env Rails.env
  json.url request.url
end
