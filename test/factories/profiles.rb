# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    id { 'translator' }
    name { 'Translator' }
    description { 'Translator from PL to EN and vice versa' }
    content { "You are a translator. For every message you receive, translate it into Polish or English based on the source language.\nIf the message is in English, translate it into Polish.\n If the message is in Polish, translate it into English.\nApply this rule to each request, not just the first one.\nEven if the message is a question, translate the text without answering it.\nDo not add any notes or additional information, only return the translation itself.\nTranslate in a way that sounds natural to a native speaker of the target language. Only return the translation of the text; you don’t need to translate any code." }
    providers { %w[open_ai groq ollama] }

    factory :translator_profile do
      id { 'translator' }
    end
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id          :string           not null, primary key
#  content     :text
#  description :string
#  name        :string
#  providers   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
