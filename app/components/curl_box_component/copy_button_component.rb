# frozen_string_literal: true

class CurlBoxComponent::CopyButtonComponent < ViewComponent::Base
  include ActiveModel::Model
  attr_accessor :target
end
