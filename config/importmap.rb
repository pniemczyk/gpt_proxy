# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'

if Rails.env.development?
  pin 'env', to: 'env_development.js'
elsif Rails.env.production?
  pin 'env', to: 'env_production.js'
end
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
