# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  renders_one :icon, IconComponent
  attr_accessor :title, :color, :data, :path, :target
  def initialize(title:, color: 'blue', data: {}, path: nil, target: nil) = super

  def button_classes
    base_classes = 'py-2 px-3 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent'
    color_classes = "bg-#{color}-600 text-white hover:bg-#{color}-700 focus:outline-none focus:bg-#{color}-700"
    "#{base_classes} #{color_classes} disabled:opacity-50 disabled:pointer-events-none"
  end
end
