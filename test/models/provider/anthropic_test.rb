# frozen_string_literal: true

require 'test_helper'

class Provider::AnthropicTest < ActiveSupport::TestCase
  setup do
    @profile = create(:translator_profile, providers: [ 'anthropic' ])
    @provider = create(:anthropic_provider)
    @subject = Provider::Anthropic
  end
  attr_reader :subject, :provider, :profile

  vcr_test '#ask' do
    body = { 'answer' => 'The capital of France is Paris.', 'ref_id' => 'msg_018wtSG4s6SsfZA7ojQAVh7v' }
    result = subject.ask('What is the capital of France?') do |res|
      # block usage
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal nil, res.profile
    end
    # direct usage
    assert_equal body, result.body
  end

  vcr_test '#ask with profile' do
    body = { 'answer' => 'Jaka jest stolica Francji?', 'ref_id' => 'msg_013YGra3MMKHhLMxDXHQmipi' }
    result = subject.ask('What is the capital of France?', profile: profile.id) do |res|
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal profile.id, res.profile
    end
    assert_equal body, result.body
  end

  vcr_test '#completions' do
    body = 'The capital of France is Paris.'
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal nil, res.profile
      assert_equal 'stop', res.body.finish_reason
    end
    assert_equal body, result.body.message.content
  end

  vcr_test '#completions with profile' do
    body = 'Jaka jest stolica Francji?'
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }, profile: profile.id) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal profile.id, res.profile
    end
    assert_equal body, result.body.message.content
  end

  vcr_test '#completions with previous context' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'The capital of France is Paris.' },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = 'The capital of Poland is Warsaw.'
    subject.completions({ messages: messages }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal nil, res.profile
    end
  end

  vcr_test '#completions with previous context and profile' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'Jaka jest stolica Francji?' },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = 'Jaka jest stolica Polski?'
    subject.completions({ messages: messages }, profile: profile.id) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'claude-3-5-sonnet-20240620', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :content, 0, :text)
      assert_equal profile.id, res.profile
    end
  end

  vcr_test '#chat' do
    payload = {
      model: 'claude-3-5-sonnet-20240620',
      messages: [
        {
          role: 'user',
          content: "What's is the capital of Germany?"
        }
      ],
      max_tokens: 50,
      temperature: 0.7
    }
    text = "The capital of Germany is Berlin. \n\nBerlin has been the capital of Germany since 1990, following the reunification of East and West Germany. Before that, it was the capital of East Germany, while Bonn served as the capital" # rubocop:disable Layout/LineLength
    result = subject.chat(payload) do |res|
      assert_equal 200, res.status
      assert_equal 'claude-3-5-sonnet-20240620', res.body.dig(:model)
      assert_equal text, res.body.dig(:content, 0, :text)
    end

    assert_equal 200, result.status
    assert_equal 'claude-3-5-sonnet-20240620', result.body.dig(:model)
    assert_equal text, result.body.dig(:content, 0, :text)
  end

  vcr_test '#chat when model not found' do
    payload = {
      model: 'unk_gpt-3.5-turbo',
      messages: [
        {
          role: 'user',
          content: "What's is the capital of Germany?"
        }
      ],
      max_tokens: 50,
      temperature: 0.7
    }
    assert_raises(FaradayClient::ErrorResponse) { subject.chat(payload) }
  end
end
