# frozen_string_literal: true

class Base::EndpointComponentPreview < ViewComponent::Preview
  def default
    render(Base::EndpointComponent.new(method: :put, path: "path", label: :proxy))
  end
end
