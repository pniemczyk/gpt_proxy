# frozen_string_literal: true

class ProviderCardComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :provider
end
