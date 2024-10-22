# frozen_string_literal: true

class Layout::SidebarComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  class Link < ViewComponent::Base
    include ApplicationHelper
    include ActiveModel::Model
    attr_accessor :title, :url, :icon, :active, :target, :http_method, :data, :classes, :icon_classes
  end

  renders_many :links, Link
  renders_many :dev_links, Link
end
