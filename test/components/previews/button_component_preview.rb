# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  def default
    render(ButtonComponent.new(title: "My button", color: :blue, data: {test_id: 1}, path: "path"))
  end
end
