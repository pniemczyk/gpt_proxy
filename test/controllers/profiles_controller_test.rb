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

  # test "should create profile" do
  #   assert_difference('Profile.count') do
  #     post profiles_url, params: { profile: { content: subject.content, description: subject.description, name: subject.name, providers: subject.providers } }
  #   end
  #
  #   assert_redirected_to profile_url(Profile.last)
  # end
  #
  # test "should show profile" do
  #   get profile_url(subject)
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get edit_profile_url(subject)
  #   assert_response :success
  # end
  #
  # test "should update profile" do
  #   patch profile_url(subject), params: { profile: { content: subject.content, description: subject.description, name: subject.name, providers: subject.providers } }
  #   assert_redirected_to profile_url(subject)
  # end
  #
  # test "should destroy profile" do
  #   assert_difference(Profile.count, -1) do
  #     delete profile_url(subject)
  #   end
  #
  #   assert_redirected_to profiles_url
  # end
end
