# frozen_string_literal: true

class CurlBoxComponentPreview < ViewComponent::Preview
  def default
    render(CurlBoxComponent.new(provider: Provider.first, endpoint: :completions, method: :chat_path, proxy_curl_response: { test: 1}, curl_response: { test: 2}))
  end
end
