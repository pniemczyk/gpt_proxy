# frozen_string_literal: true

require 'test_helper'

class Provider::OllamaTest < ActiveSupport::TestCase
  setup do
    @profile = create(:translator_profile)
    @provider = create(:ollama_provider)
    @subject = Provider::Ollama
  end
  attr_reader :subject, :provider, :profile

  vcr_test '#ask' do
    body = { 'answer' => 'The capital of France is Paris.', 'ref_id' => nil }
    result = subject.ask('What is the capital of France?') do |res|
      # block usage
      assert_equal body, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :message, :content)
      assert_equal nil, res.profile
    end
    # direct usage
    assert_equal body, result.body
  end

  vcr_test '#ask with profile' do
    body = { 'answer' => 'Stolicą Francji jest Paryż.', 'ref_id' => nil }
    result = subject.ask('What is the capital of France?', profile: profile.id) do |res|
      assert_equal body, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :message, :content)
      assert_equal profile.id, res.profile
    end
    assert_equal body, result.body
  end

  vcr_test '#completions' do
    body = 'The capital of France is Paris.'
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :message, :content)
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
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :message, :content)
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
    body = 'The capital of Poland is Warsaw (Polish: Warszawa).'
    subject.completions({ messages: messages }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :message, :content)
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
      assert_equal 'llama3.1:70b', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :message, :content)
      assert_equal profile.id, res.profile
    end
  end

  vcr_test '#chat' do
    payload = {
      model: 'llama3.1:70b',
      messages: [
        {
          role: 'user',
          content: "What's is the capital of Germany?"
        }
      ],
      max_tokens: 50,
      temperature: 0.7,
      stream: false
    }

    result = subject.chat(payload) do |res|
      assert_equal 200, res.status
      assert_equal 'llama3.1:70b', res.body.dig(:model)
      assert_equal 'The capital of Germany is Berlin.', res.body.dig(:message, :content)
    end

    assert_equal 200, result.status
    assert_equal 'llama3.1:70b', result.body.dig(:model)
    assert_equal 'The capital of Germany is Berlin.', result.body.dig(:message, :content)
  end

  vcr_test '#chat when model not found' do
    payload = {
      model: 'unk_llama3.1:70b',
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
