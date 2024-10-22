# frozen_string_literal: true

class CurlBoxComponent::CodePanelComponent < ViewComponent::Base
  include ActiveModel::Model
  attr_accessor :code, :language, :tab_index, :target, :auto_format, :active
  def initialize(code:, language:, tab_index:, target:, auto_format: false, active: false)
    super(active:, code:, language: language.to_s.inquiry, tab_index:, target:, auto_format:)
  end

  def code = auto_format && language.json? ?  JSON.pretty_generate(@code) : @code
end
