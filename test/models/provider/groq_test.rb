# frozen_string_literal: true

require 'test_helper'

class Provider::GroqTest < ActiveSupport::TestCase
  setup do
    @profile = create(:translator_profile)
    @provider = create(:groq_provider)
    @subject = Provider::Groq
  end
  attr_reader :subject, :provider, :profile

  vcr_test '#ask' do
    body = { 'answer' => 'The capital of France is Paris.', 'ref_id' => 'chatcmpl-26660a1d-4f2d-4e1b-83b4-28bb90dfb829' }
    result = subject.ask('What is the capital of France?') do |res|
      # block usage
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal nil, res.profile
    end
    # direct usage
    assert_equal body.as_json, result.body
  end

  vcr_test '#ask with profile' do
    body = { 'answer' => 'Stolica Francji to Paryż.', 'ref_id' => 'chatcmpl-edaa5351-fc53-49c7-afc7-e63d8c3ca696' }
    result = subject.ask('What is the capital of France?', profile: profile.id) do |res|
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
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
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal nil, res.profile
      assert_equal 'stop', res.body.finish_reason
    end
    assert_equal body, result.body.message.content
  end

  vcr_test '#completions with profile' do
    body = 'Stolica Francji to Paryż.'
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }, profile: profile.id) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
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
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal nil, res.profile
    end
  end

  vcr_test '#completions with previous context and profile' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'Jaka jest stolica Francji?' },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = 'Stolica Polski to Warszawa.'
    subject.completions({ messages: messages }, profile: profile.id) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal 'llama3-8b-8192', res.metadata.dig(:response, :body, :model)
      assert_equal body, res.metadata.dig(:response, :body, :choices, 0, :message, :content)
      assert_equal profile.id, res.profile
    end
  end

  vcr_test '#chat' do
    payload = {
      model: 'llama3-8b-8192',
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
      assert_equal 'llama3-8b-8192', res.body.dig(:model)
      assert_equal 'The capital of Germany is Berlin.', res.body.dig(:choices, 0, :message, :content)
    end

    assert_equal 200, result.status
    assert_equal 'llama3-8b-8192', result.body.dig(:model)
    assert_equal 'The capital of Germany is Berlin.', result.body.dig(:choices, 0, :message, :content)
  end

  vcr_test '#chat when model not found' do
    payload = {
      model: 'unk_llama3-8b-8192',
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
    assert_equal %w[llama3-70b-8192 gemma2-9b-it llama3-8b-8192 llama-3.2-11b-text-preview llama3-groq-8b-8192-tool-use-preview llama-3.2-11b-vision-preview llama-3.2-90b-text-preview llama-guard-3-8b llama-3.2-90b-vision-preview llama-3.1-8b-instant mixtral-8x7b-32768 whisper-large-v3 llama-3.2-1b-preview llava-v1.5-7b-4096-preview llama3-groq-70b-8192-tool-use-preview gemma-7b-it llama-3.1-70b-versatile whisper-large-v3-turbo distil-whisper-large-v3-en llama-3.2-3b-preview], result # rubocop:disable Layout/LineLength
  end
end
