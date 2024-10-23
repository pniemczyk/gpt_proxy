# frozen_string_literal: true

require 'test_helper'

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup { @subject = create(:ollama_provider) }
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

  test 'should show models' do
    get models_provider_url(subject)
    assert_response :success
    assert_includes response.body, 'models'
  end

  def ollama_response
    {
      model: 'llama3.1:70b',
      created_at: '2024-10-23T20:27:23.431565Z',
      message: { role: 'assistant', content: 'The capital of Germany is Berlin.' },
      done_reason: 'stop',
      done: true,
      total_duration: 2074655459,
      load_duration: 173849959,
      prompt_eval_count: 18,
      prompt_eval_duration: 1021818000,
      eval_count: 8,
      eval_duration: 877961000
    }
  end

  test 'should give response for the question' do
    question = 'What is the capital of France?'
    body = { ref_id: nil, answer: 'The capital of France is Paris.' }
    metadata = { response: { status: 200, body: ollama_response } }
    result = Hashie::Mash.new(body: body, metadata: metadata)

    Provider::Ollama.expects(:ask).returns(result)
    post ask_provider_url(subject, format: :json), params: { question: }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)

    expected_body = body.merge(
      'proxy' => {
        'profile' => nil,
        'status' => 200,
        'original_body' => ollama_response
      },
      'info' => {
        'app' => 'GptProxy',
        'env' => 'test',
        'current_url' => 'http://localhost:3000/providers/ollama/ask.json',
        'provider' => 'Ollama'
      }
    )

    assert_equal expected_body.deep_stringify_keys, json_response
  end

  test 'should give response for the completion' do
    payload = { stream: false, messages: [{ role: 'user', content: "What's is the capital of Germany?" }], model: 'llama3.1:70b' }
    body = { ref_id: nil, message: { role: 'assistant', content: 'The capital of France is Paris.' }, model: 'llama3.1:70b', finish_reason: 'stop' }
    metadata = { response: { status: 200, body: ollama_response } }
    result = Hashie::Mash.new(body: body, metadata: metadata)
    Provider::Ollama.expects(:completions).returns(result)

    post completions_provider_url(subject, format: :json), params: { payload: }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)

    expected_body = body.merge(
      'proxy' => {
        'profile' => nil,
        'status' => 200,
        'original_body' => ollama_response
      },
      'info' => {
        'app' => 'GptProxy',
        'env' => 'test',
        'current_url' => 'http://localhost:3000/providers/ollama/completions.json',
        'provider' => 'Ollama'
      }
    )

    assert_equal expected_body.deep_stringify_keys, json_response
  end

  test 'should give response for the chat as direct request/response of the provider' do
    payload = { model: 'llama3.1:70b', messages: [{ role: 'user', content: "What's is the capital of Germany?" }], max_tokens: 50, temperature: 0.7, stream: false }
    body = ollama_response
    result = Hashie::Mash.new(body:)
    Provider::Ollama.expects(:chat).returns(result)

    post chat_provider_url(subject, format: :json), params: { payload: }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)

    expected_body = body.merge(
      'info' => {
        'app' => 'GptProxy',
        'env' => 'test',
        'url' => 'http://localhost:3000/providers/ollama/chat.json',
        'provider' => 'Ollama'
      }
    )

    assert_equal expected_body.deep_stringify_keys, json_response
  end
end
