# frozen_string_literal: true

# require "test_helper"
#
# describe ProvidersController do
#   let(:provider) { providers(:one) }
#
#   it "should get index" do
#     get providers_url
#     must_respond_with :success
#   end
#
#   it "should get new" do
#     get new_provider_url
#     must_respond_with :success
#   end
#
#   it "should create provider" do
#     assert_difference("Provider.count") do
#       post providers_url, params: { provider: { api_key: @provider.api_key, chat_path: @provider.chat_path, default_model: @provider.default_model, headers_options: @provider.headers_options, info: @provider.info, models: @provider.models, models_path: @provider.models_path, name: @provider.name, payload_options: @provider.payload_options, profilable: @provider.profilable, url: @provider.url } } # rubocop:disable Layout/LineLength
#     end
#
#     must_redirect_to provider_url(Provider.last)
#   end
#
#   it "should show provider" do
#     get provider_url(@provider)
#     must_respond_with :success
#   end
#
#   it "should get edit" do
#     get edit_provider_url(@provider)
#     must_respond_with :success
#   end
#
#   it "should update provider" do
#     patch provider_url(@provider), params: { provider: { api_key: @provider.api_key, chat_path: @provider.chat_path, default_model: @provider.default_model, headers_options: @provider.headers_options, info: @provider.info, models: @provider.models, models_path: @provider.models_path, name: @provider.name, payload_options: @provider.payload_options, profilable: @provider.profilable, url: @provider.url } } # rubocop:disable Layout/LineLength
#     must_redirect_to provider_url(@provider)
#   end
#
#   it "should destroy provider" do
#     assert_difference("Provider.count", -1) do
#       delete provider_url(@provider)
#     end
#
#     must_redirect_to providers_url
#   end
# end
