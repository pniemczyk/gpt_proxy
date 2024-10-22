# frozen_string_literal: true

class GroupButtonsComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  class Button < ViewComponent::Base
    include ApplicationHelper
    include ActiveModel::Model
    attr_accessor :title, :url, :icon, :target, :http_method, :data
  end

  renders_many :buttons, Button
end
