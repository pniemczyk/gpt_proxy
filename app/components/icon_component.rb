# frozen_string_literal: true

class IconComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :name, :size, :hidden, :data, :classes
  def initialize(name:, size: 4, hidden: false, data: {}, classes: nil) = super(name: name.to_s.inquiry, size: size.to_i, hidden:, data:, classes:)
  def viewbox = name.github? ? '0 0 96 96' : '0 0 24 24'
end
