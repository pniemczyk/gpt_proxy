# frozen_string_literal: true

class Profile < ApplicationRecord
  attribute :id, :string
  attribute :name, :string
  attribute :description, :string, default: ''
  attribute :content, :string, default: ''
  attribute :providers, :json, default: []

  validates :name, presence: true
  validates :content, presence: true
  validate :providers_must_be_valid
  before_validation -> { self.name = id.to_s.humanize if name.blank? }
  before_validation -> { self.name = id.to_s.downcase.strip if name.blank? }

  def providers_must_be_valid
    invalid_providers = providers.map(&:to_s) - Provider::IDS
    return unless invalid_providers.any?

    errors.add(:providers, "contains invalid providers: #{invalid_providers.join(', ')}")
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id          :string           not null, primary key
#  content     :text
#  description :string
#  name        :string
#  providers   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
