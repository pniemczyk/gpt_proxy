# frozen_string_literal: true

module ApplicationHelper
  def vc(name, **kwargs, &block)
    component_class = "::#{name.to_s.camelize}Component"
    render component_class.constantize.new(**kwargs), &block
  rescue NameError => e
    raise e, "Component #{name} as #{component_class} Error: #{e.message}"
  end

  def current_host = "#{request.protocol}#{request.host_with_port}"
  def path_for(source, path) = "#{url_for(source)}/#{path}"
end
