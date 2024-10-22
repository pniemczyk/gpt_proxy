# frozen_string_literal: true

require 'test_helper'

class Provider::GeminiTest < ActiveSupport::TestCase
  setup do
    @provider = create(:gemini_provider)
    @subject = Provider::Gemini
  end
  attr_reader :subject, :provider

  vcr_test '#ask' do
    body = { 'answer' => "The capital of France is **Paris**. \n", 'ref_id' => nil }
    result = subject.ask('What is the capital of France?') do |res|
      # block usage
      assert_equal body.as_json, res.body
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal body['answer'], res.metadata.dig(:response, :body, :candidates, 0, :content, :parts, 0, :text)
      assert_equal nil, res.profile
    end
    # direct usage
    assert_equal body, result.body
  end

  vcr_test '#completions' do
    body = "The capital of France is **Paris**. \n"
    result = subject.completions({ messages: [ { role: 'user', content: 'What is the capital of France?' } ] }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal body, res.metadata.dig(:response, :body, :candidates, 0, :content, :parts, 0, :text)
      assert_equal nil, res.profile
      assert_equal 'stop', res.body.finish_reason
    end
    assert_equal body, result.body.message.content
  end

  vcr_test '#completions with previous context' do
    messages = [
      { role: 'user', content: 'What is the capital of France?' },
      { role: 'assistant', content: 'The capital of France is Paris.', refusal: nil },
      { role: 'user', content: 'What is the capital of Poland?' }
    ]
    body = "The capital of Poland is **Warsaw**. \n"
    subject.completions({ messages: messages }) do |res|
      assert_equal body, res.body.message.content
      assert_equal 200, res.metadata.dig(:response, :status)
      assert_equal body, res.metadata.dig(:response, :body, :candidates, 0, :content, :parts, 0, :text)
      assert_equal nil, res.profile
    end
  end

  vcr_test '#chat' do
    payload = { contents: [ { parts: [ { text: 'What is the capital of France?' } ] } ] }

    text = "The capital of France is **Paris**. \n"
    result = subject.chat(payload) do |res|
      assert_equal 200, res.status
      assert_equal text, res.body.dig(:candidates, 0, :content, :parts, 0, :text)
    end

    assert_equal 200, result.status
    assert_equal text, result.body.dig(:candidates, 0, :content, :parts, 0, :text)
  end

  vcr_test '#chat when model not found' do
    payload = { contents: [ { parts: [ { text: 'What is the capital of France?' } ] } ] }
    assert_raises(FaradayClient::ErrorResponse) { subject.chat(payload, model: 'unk') }
  end

  vcr_test '#models' do
    result = subject.models.map { |m| m['name'].gsub('models/', '') }
    assert_equal %w[chat-bison-001 text-bison-001 embedding-gecko-001 gemini-1.0-pro-latest gemini-1.0-pro gemini-pro gemini-1.0-pro-001 gemini-1.0-pro-vision-latest gemini-pro-vision gemini-1.5-pro-latest gemini-1.5-pro-001 gemini-1.5-pro-002 gemini-1.5-pro gemini-1.5-pro-exp-0801 gemini-1.5-pro-exp-0827 gemini-1.5-flash-latest gemini-1.5-flash-001 gemini-1.5-flash-001-tuning gemini-1.5-flash gemini-1.5-flash-exp-0827 gemini-1.5-flash-002 gemini-1.5-flash-8b gemini-1.5-flash-8b-001 gemini-1.5-flash-8b-latest gemini-1.5-flash-8b-exp-0827 gemini-1.5-flash-8b-exp-0924 embedding-001 text-embedding-004 aqa], result # rubocop:disable Layout/LineLength
  end
end
