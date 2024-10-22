# frozen_string_literal: true

class Doc::FieldComponentPreview < ViewComponent::Preview
  def default
    render(Doc::FieldComponent.new(name: "name", details: "details", type: "type", required: "required"))
  end
end
