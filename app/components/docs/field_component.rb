# frozen_string_literal: true

class Docs::FieldComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  renders_one :child
  attr_accessor :name, :details, :type, :required, :optional
  def initialize(name:, details:, type: :string, required: false, optional: false)= super
end
