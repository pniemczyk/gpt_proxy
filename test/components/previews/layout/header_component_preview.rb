# frozen_string_literal: true

class Layout::HeaderComponentPreview < ViewComponent::Preview
  # HeaderComponent
  # ------------
  # Usage example:
  #
  # ```slim
  # = render Layout::HeaderComponent.new(title: 'Project Overview', details: 'This project demonstrates the implementation of a stock price history chart for multiple stocks') do |cmp|
  #   = cmp.with_button do
  #     = link_to "Let's Start", stocks_path, class: "inline-block rounded bg-indigo-600 px-5 py-3 text-sm font-medium text-white transition hover:bg-indigo-700 focus:outline-none focus:ring"
  # ```
  # @param title text "Just a title"
  # @param details text "Description of the title"
  def default(title: 'My awesome title', details: 'Lorem ipsum...')
    render(Layout::HeaderComponent.new(title: title, details: details)) do |cmp|
      cmp.with_button { fake_link.html_safe }
    end
  end

  private

  def fake_link = '<a class="inline-block rounded bg-indigo-600 px-5 py-3 text-sm font-medium text-white transition hover:bg-indigo-700 focus:outline-none focus:ring" href="#">Let\'s Start</a>'
end
