# frozen_string_literal: true

class Base::CopyTextComponentPreview < ViewComponent::Preview
  def default
    render(Base::CopyTextComponent.new(text: "text"))
  end
end
