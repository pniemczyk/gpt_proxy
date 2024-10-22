# frozen_string_literal: true

class ProvidersController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token, only: %i[ask completions chat]
  rescue_from FaradayClient::ErrorResponse, with: :handle_proxy_error

  def index = render locals: { providers: repo.all }
  def edit = render locals: { provider: }
  def update = generic_update(provider, provider_params)
  def destroy = generic_destroy(provider)

  def models
    result = models_full? ? Hashie::Mash.new(body: { models: provider.proxy.models }) : provider.proxy.model_names rescue Hashie::Mash.new(body: { models: provider.models }) # rubocop:disable Layout/LineLength
    render locals: { provider:, result: }
  end
  def ask = render locals: { provider:, result: provider.proxy.ask(question, **ask_additional_params) }
  def completions = render locals: { provider:, result: provider.proxy.completions(payload, **completions_additional_params) }
  def chat = render locals: { provider:, result: provider.proxy.chat(payload) }

  def show
    docs = %i[ask models completions].map { |ent| [ ent, Captured::Endpoint.last_record(provider.id, ent) ] }.to_h
    render locals: { provider:, docs: }
  end

  def refresh_docs # rubocop:disable Metrics/AbcSize
    url = URI.join(current_host, path_for(provider, docs_params[:endpoint])).to_s
    capture do
      case docs_params[:endpoint]
      when 'models'
        body = JSON.parse(render_to_string(docs_params[:endpoint], locals: { provider:, result: provider.proxy.model_names }, formats: :json))
        capture_endpoint(url:, body:)
      when 'ask'
        question = 'When Albert Einstein died.'
        result = provider.proxy.ask(question)
        body = JSON.parse(render_to_string(docs_params[:endpoint], locals: { provider:, result: }, formats: :json))
        capture_endpoint(method: :post, url:, body:, params: { question:, profile: nil, model: nil, options: nil })
      when 'completions'
        req = { messages: [ { role: :user, content: 'When Albert Einstein died.' } ] }
        result = provider.proxy.completions(req)
        body = JSON.parse(render_to_string(docs_params[:endpoint], locals: { provider:, result: }, formats: :json))
        capture_endpoint(method: :post, url:, body:, params: req.merge(profile: nil, options: nil))
      end
    end
    flash[:success] = 'Docs refreshed!'
    redirect_to provider_path(provider)
  end

  private

  def capture(&block) = ::Faraday::Capture.capture(&block)
  def capture_endpoint(**args) = Captured::Endpoint.create!(**args)
  def repo = Provider
  def provider = @provider ||= repo.find(params.required(:id))
  def question = params.require(:question)
  def ask_additional_params = params.permit(:profile, :model, :options).permit!.to_h # TODO: Improve permiting
  def payload = params.require(:payload).permit!.to_h
  def completions_additional_params = params.permit(:profile, :options).permit!.to_h
  def handle_proxy_error(error) = render :proxy_error, locals: { provider:, error:, status: error.status }, status: error.status, formats: :json
  def docs_params = params.permit(:endpoint).permit!.to_h
  def models_full? = ActiveModel::Type::Boolean.new.cast(params[:full])

  def provider_params
    params.expect(provider: [ :name, :api_key, :url, :chat_path, :models_path, :default_model, :info, :models, :payload_options, :headers_options, :profilable ]).tap do |wl|
      wl[:models] = wl[:models].split(',').map(&:strip).compact if wl[:models].present? && wl[:models].is_a?(String)
      wl[:payload_options] = JSON.parse(wl[:payload_options]) if wl[:payload_options].present?
      wl[:headers_options] = JSON.parse(wl[:headers_options]) if wl[:headers_options].present?
      wl[:profilable] = ActiveModel::Type::Boolean.new.cast(wl[:profilable])
    end
  end
end
