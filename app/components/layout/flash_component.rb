# frozen_string_literal: true

class Layout::FlashComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :type, :message
  def initialize(type: nil, message:) = super(type: (type.presence || :notice).to_sym, message:)

  COLORS = {
    notice: :blue,
    info: :blue,
    alert: :red,
    error: :red,
    success: :green,
    warning: :yellow
  }.freeze

  ICON = {
    notice: :info,
    alert: :error
  }.freeze

  def color = @color ||= COLORS[type] || :gray
  def icon = @icon ||= ICON[type] || type
end
