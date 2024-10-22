# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index = render locals: { profiles: repo.all }
  def show = render locals: { profile: }
  def new = render locals: { profile: repo.new }
  def edit = render locals: { profile: }
  def create = generic_create(repo, profile_params)
  def update = generic_update(profile, profile_params)
  def destroy = generic_destroy(profile)

  private

  def repo = Profile
  def profile = @profile ||= repo.find(params.expect(:id))
  def profile_params = params.require(:profile).permit(:id, :name, :description, :content, providers: []).tap do |wl|
    wl[:providers].reject!(&:blank?) if wl[:providers].present?
  end
end
