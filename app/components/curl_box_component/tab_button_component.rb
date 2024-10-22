# frozen_string_literal: true

class CurlBoxComponent::TabButtonComponent < ViewComponent::Base
  include ActiveModel::Model
  attr_accessor :active, :label, :tab_index, :target
end
