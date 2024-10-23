# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require_relative 'support/vcr_setup'
require 'pry-rails'

require 'minitest/autorun'
require 'mocha/minitest'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include VcrTestHelper

  # Run tests in parallel with specified workers use PARALLEL_WORKERS to manually set the number of workers
  # like PARALLEL_WORKERS=4 rails test
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
