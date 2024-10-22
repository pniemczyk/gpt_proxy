# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index = render locals: { info: File.read(Rails.root.join('README.md')) }
end
