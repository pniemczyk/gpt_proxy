# frozen_string_literal: true

class ProfileCardComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :profile
end
