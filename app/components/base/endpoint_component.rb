# frozen_string_literal: true

class Base::EndpointComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :method_name, :host, :path, :show_with_host, :full, :label
  renders_one :child
  def initialize(label: nil, method: nil, host: nil, path:, full: false, show_with_host: false)
    super(
      method_name: (method.presence || 'get').to_s.inquiry,
      host:, show_with_host:, full:, label:,
      path: path.start_with?('/') ? path : "/#{path}"
    )
  end

  COLORS = {
    get: :blue,
    post: :green,
    put: :yellow,
    delete: :red,
    patch: :orange,
    head: :purple,
    options: :indigo,
    trace: :pink,
    connect: :teal
  }.freeze

  def color = @color ||= COLORS[method_name&.to_sym] || :gray
  def with_host = @with_host ||= [ host, path ].compact.join('/')
end
