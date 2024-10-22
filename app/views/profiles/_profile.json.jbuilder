# frozen_string_literal: true

json.extract! profile, :id, :name, :description, :content, :providers, :created_at, :updated_at
json.proxy_url profile_url(profile, format: :json)
