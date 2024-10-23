# frozen_string_literal: true

require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup { @subject = build(:profile) }
  attr_reader :subject

  test 'should get index' do
    get profiles_url
    assert_response :success
  end

  test 'should get new' do
    get new_profile_url
    assert_response :success
  end

  test 'should create profile' do
    assert_difference('Profile.count') do
      post profiles_url, params: { profile: { content: 'Test', description: 'none', id: 'ruby', providers: [ 'groq' ] } }
    end

    assert_redirected_to profiles_url
  end

  test 'should show profile' do
    subject.save!
    get profile_url(subject)
    assert_response :success
  end

  test 'should get edit' do
    subject.save!
    get edit_profile_url(subject)
    assert_response :success
  end

  test 'should update profile' do
    subject.save!
    patch profile_url(subject), params: { profile: { content: subject.content, description: subject.description, name: subject.name, providers: subject.providers } }
    assert_redirected_to profiles_url
  end

  test 'should destroy profile' do
    subject.save!
    assert_difference('Profile.count', -1) do
      delete profile_url(subject)
    end

    assert_redirected_to profiles_url
  end
end
