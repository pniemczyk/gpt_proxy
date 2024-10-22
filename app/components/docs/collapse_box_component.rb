# frozen_string_literal: true

class Docs::CollapseBoxComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  renders_one :child
  attr_accessor :title, :collapsed
  def initialize(title: 'child attributes', collapsed: true) = super
end
