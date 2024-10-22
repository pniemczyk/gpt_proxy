# frozen_string_literal: true

class Layout::HeaderComponent < ViewComponent::Base
  renders_many :buttons

  def initialize(title:, details:)
    @title = title
    @details = details
  end

  attr_reader :title, :details
end
