# frozen_string_literal: true

require 'test_helper'

class Provider::OpenAiTest < ActiveSupport::TestCase
  setup do
    @profile = create(:translator_profile)
    @provider = create(:open_ai_provider)
    @subject = Provider::OpenAi
  end
  attr_reader :subject, :provider, :profile

  vcr_test '#ask' do
    body = { 'answer' => 'The capital of France is Paris.', 'ref_id' => 'chatcmpl-AIjVN7sEeZBY8scrBBE6rpRyKQdNJ' }
    result = subject.ask('What is the capital of France?') do |res|
      # block usage
      assert_equal body, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal nil, res.profile
    end
    # direct usage
    assert_equal body, result.body
  end

  vcr_test '#ask with profile' do
    body = { 'answer' => 'Jaka jest stolica Francji?', ref_id: 'chatcmpl-AIjdMigK8QdRL9r0B5TXLFJmVX2bZ' }
    result = subject.ask('What is the capital of France?', profile: profile.id) do |res|
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal profile.id, res.profile
    end
    assert_equal body.as_json, result.body
  end

  vcr_test '#completions' do
    body = 'The capital of France is Paris.'
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
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
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal profile.id, res.profile
    end
    assert_equal body, result.body.message.content
  end

  vcr_test '#completions with previous context' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'The capital of France is Paris.', refusal: nil },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = 'The capital of Poland is Warsaw.'
    subject.completions({ messages: messages }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal nil, res.profile
    end
  end

  vcr_test '#completions with previous context and profile' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'Jaka jest stolica Francji?', refusal: nil },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = 'Jaka jest stolica Polski?'
    subject.completions({ messages: messages }, profile: profile.id) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'gpt-3.5-turbo-0125', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal profile.id, res.profile
    end
  end

  vcr_test '#chat' do
    payload = {
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: 'user',
          content: "What's is the capital of Germany?"
        }
      ],
      max_tokens: 50,
      temperature: 0.7
    }

    result = subject.chat(payload) do |res|
      assert_equal 200, res.status
      assert_equal 'gpt-3.5-turbo-0125', res.body.dig(:model)
      assert_equal 'The capital of Germany is Berlin.', res.body.dig(:choices, 0, :message, :content)
    end

    assert_equal 200, result.status
    assert_equal 'gpt-3.5-turbo-0125', result.body.dig(:model)
    assert_equal 'The capital of Germany is Berlin.', result.body.dig(:choices, 0, :message, :content)
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

  vcr_test '#models' do
    result = subject.models.map { |m| m['id'] }
    assert_equal %w[gpt-4-turbo gpt-4-turbo-2024-04-09 tts-1 tts-1-1106 chatgpt-4o-latest dall-e-2 gpt-4-turbo-preview gpt-4o-2024-08-06 gpt-3.5-turbo-instruct gpt-4o gpt-4-0125-preview gpt-3.5-turbo-0125 gpt-3.5-turbo babbage-002 davinci-002 gpt-4o-realtime-preview-2024-10-01 dall-e-3 gpt-4o-realtime-preview gpt-4o-2024-05-13 tts-1-hd tts-1-hd-1106 gpt-4-1106-preview text-embedding-ada-002 gpt-3.5-turbo-16k text-embedding-3-small text-embedding-3-large whisper-1 gpt-4o-mini gpt-4o-mini-2024-07-18 gpt-3.5-turbo-1106 gpt-4-0613 gpt-4 gpt-3.5-turbo-instruct-0914], result # rubocop:disable Layout/LineLength
  end
end
