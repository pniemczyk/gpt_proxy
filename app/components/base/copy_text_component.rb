# frozen_string_literal: true

class Base::CopyTextComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :text, :slim, :hidden, :hidden_length
  def initialize(text:, slim: false, hidden: false, hidden_length: nil) = super
end
