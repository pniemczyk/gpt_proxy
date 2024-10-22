# frozen_string_literal: true

require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  setup { @subject = build(:provider) }
  attr_reader :subject

  test 'must be valid' do
    assert subject.valid?
  end

  test 'name is auto-generated before validation based on the id' do
    subject.name = nil
    assert subject.valid?
    assert_includes subject.name, subject.id.humanize
  end

  test 'must have a id' do
    subject.id = nil
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, "Id can't be blank"
  end

  test 'id must be valid' do
    subject.id = 'invalid'
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, 'Id is not included in the list'
  end

  test 'api_key must be present' do
    subject.api_key = nil
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, "Api key can't be blank"
  end

  test 'url must be present' do
    subject.url = nil
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, "Url can't be blank"
  end

  test 'chat_path must be present' do
    subject.chat_path = nil
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, "Chat path can't be blank"
  end
end

# == Schema Information
#
# Table name: providers
#
#  id              :string           not null, primary key
#  api_key         :string
#  chat_path       :string
#  default_model   :string
#  headers_options :text
#  info            :text
#  models          :text
#  models_path     :string
#  name            :string
#  payload_options :text
#  profilable      :boolean
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
