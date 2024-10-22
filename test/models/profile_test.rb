# frozen_string_literal: true

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  setup { @subject = build(:profile) }
  attr_reader :subject

  test 'must be valid' do
    assert subject.valid?
  end

  test 'name is auto-generated before validation based on the id' do
    subject.name = nil
    assert subject.valid?
    assert_includes subject.name, subject.id.humanize
  end

  test 'must have content' do
    subject.content = nil
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, "Content can't be blank"
  end

  test 'must have valid providers' do
    subject.providers = %w[invalid]
    assert_not subject.valid?
    assert_includes subject.errors.full_messages, 'Providers contains invalid providers: invalid'
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id          :string           not null, primary key
#  content     :text
#  description :string
#  name        :string
#  providers   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
