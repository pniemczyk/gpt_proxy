# frozen_string_literal: true

class Captured::Response < ApplicationRecord
  belongs_to :request, class_name: '::Captured::Request'

  attribute :status, :integer
  attribute :headers, :json, default: {}
  attribute :body, :string

  validates :status, presence: true

  def json_body
    JSON.parse(body)
  rescue JSON::ParserError
    {}
  end
end
