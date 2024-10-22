# frozen_string_literal: true

class Captured::Endpoint < ApplicationRecord
  attribute :method, :string, default: 'GET'
  attribute :url, :string
  attribute :params, :json, default: {}
  attribute :headers, :json, default: {}
  attribute :payload, :json, default: {}
  attribute :status, :integer, default: 200
  attribute :body, :json, default: {}

  before_validation -> { self.method = method.to_s.upcase }

  validates :method, presence: true
  validates :url, presence: true
  validates :status, presence: true

  def self.last_record(provider_id, endpoint_name) = where('url LIKE ?', "%/providers/#{provider_id}/#{endpoint_name}").order(created_at: :desc).first
end
