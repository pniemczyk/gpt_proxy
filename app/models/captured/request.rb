# frozen_string_literal: true

class Captured::Request < ApplicationRecord
  has_one :response, class_name: '::Captured::Response', dependent: :destroy

  attribute :ref_id, :string
  attribute :method, :string
  attribute :url, :string
  attribute :headers, :json, default: {}
  attribute :body, :string

  before_validation -> { self.method = method.to_s.upcase }

  validates :ref_id, presence: true
  validates :method, presence: true
  validates :url, presence: true

  def json_body
    JSON.parse(body)
  rescue JSON::ParserError
    {}
  end
end
