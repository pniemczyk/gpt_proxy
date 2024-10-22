# frozen_string_literal: true

class Provider < ApplicationRecord
  IDS = %w[anthropic copilot gemini groq ollama open_ai].freeze

  class Info
    include StoreModel::Model

    attribute :homepage, :string
    attribute :documentation, :string
    attribute :models, :string
    attribute :key_generation, :string
    attribute :github, :string
  end

  attribute :name, :string
  attribute :api_key, :string, default: nil
  attribute :url, :string, default: ''
  attribute :chat_path, :string, default: ''
  attribute :models_path, :string, default: nil
  attribute :default_model, :string, default: nil
  attribute :info, Info.to_type, default: {}
  attribute :models, :json, default: []
  attribute :payload_options, :json, default: {}
  attribute :headers_options, :json, default: {}
  attribute :profilable, :boolean, default: true

  validates :id, presence: true, uniqueness: true, inclusion: { in: IDS }
  validates :name, presence: true
  validates :url, presence: true, unless: -> { url_from_env }
  validates :chat_path, presence: true
  before_validation -> { self.name = id.to_s.humanize if name.blank? }
  after_save -> { @proxy = nil; proxy.config = self }

  scope :profilable, -> { where(profilable: true) }

  def proxy = @proxy ||= Provider.const_get(id.classify)

  # Just a hack for the ollama and app in the docker
  def url_from_env = @url_from_env ||= ENV["provider_#{id}_url".upcase]
  def url = url_from_env.presence || super
end

# == Schema Information
#
# Table name: providers
#
#  id              :string           not null, primary key
#  api_key         :string
#  chat_path       :string
#  default_model   :string
#  headers_options :text
#  info            :text
#  models          :text
#  models_path     :string
#  name            :string
#  payload_options :text
#  profilable      :boolean
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
