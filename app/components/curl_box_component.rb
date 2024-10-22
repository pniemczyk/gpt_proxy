# frozen_string_literal: true

class CurlBoxComponent < ViewComponent::Base
  include ApplicationHelper
  include ActiveModel::Model
  attr_accessor :provider, :endpoint, :method_name, :mode, :curl_response, :proxy_curl_response, :proxy_params, :params,
                :proxy_data, :data, :headers, :path
  def initialize(provider:, endpoint:, path: nil, method: :get, mode: :both, curl_response: nil, proxy_curl_response: nil, proxy_params: {}, params: {}, proxy_data: {}, data: {}, headers: {}) # rubocop:disable Metrics/ParameterLists, Layout/LineLength
    super(
      provider:, endpoint: endpoint.to_s, method_name: method.to_s.upcase, mode: mode.to_sym,
      curl_response:, proxy_curl_response:, proxy_params:, params:, proxy_data:, data:, headers:, path:
    )
  end

  def show_proxy_curl = @show_proxy_curl ||= endpoint
  def no_proxy? = @mode == :no_proxy
  def only_proxy? = @mode == :only_proxy

  def curl
    build_curl(
      method: method_name,
      url: [ provider.url, (path && provider.respond_to?(path) ? provider.public_send(path) : endpoint) ].join('/'),
      params: adjusted_params,
      headers: adjusted_headers,
      data:
    )
  end

  def adjusted_params = auth.blank? || auth[:method] != :params ? params : params.merge(auth[:key] => '<token>')

  def adjusted_headers
    return headers unless auth.present? && auth[:method] == :headers
    return headers.merge(auth[:key] => "#{auth[:type]} <token>") if auth[:key] == 'Authorization'

    headers.merge(auth[:key] => '<token>')
  end

  def proxy_curl
    build_curl(
      method: method_name,
      url: [ current_host, path_for(provider, endpoint) ].join(''),
      params: proxy_params,
      data: proxy_data
    )
  end

  def build_curl(url:, method: :get, params: {}, headers: {}, data: {})
    [
      "curl --request #{method.to_s.upcase}",
      "--url #{url}#{params.present? ? "?#{params.to_query}" : ''}",
      (headers.map { |k, v| "--header '#{k}: #{v}'" } if headers.present?),
      ("--data '#{JSON.pretty_generate(data).split("\n").join("\n    ")}'" if data.present?)
    ].compact.flatten.join(" \\\n   ")
  end

  def auth = provider.proxy.respond_to?(:auth) ? provider.proxy.auth : {}
end
