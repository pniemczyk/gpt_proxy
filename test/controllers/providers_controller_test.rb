# frozen_string_literal: true

require 'test_helper'

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup { @subject = create(:open_ai_provider) }
  attr_reader :subject

  test 'should get index' do
    get providers_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_provider_url(subject)
    assert_response :success
  end

  test 'should update provider' do
    patch(
      provider_url(subject),
      params: {
        provider: {
          api_key: '123', chat_path: subject.chat_path, default_model: subject.default_model, headers_options: subject.headers_options,
          info: subject.info, models: subject.models, models_path: subject.models_path, name: subject.name,
          payload_options: subject.payload_options, profilable: subject.profilable, url: subject.url
        }
      }
    )
    assert_redirected_to providers_url
  end

  test 'should show provider' do
    get provider_url(subject)
    assert_response :success
  end
end
