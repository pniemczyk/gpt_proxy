# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def generic_create(klass, model_params, redirect_action: :index)
    model = klass.new(model_params)

    respond_to do |format|
      if model.save
        format.html { redirect_to redirect_url_for_action(model, redirect_action), notice: "#{klass} was successfully created." }
        format.json { render :show, status: :created, location: model }
      else
        format.html { render :new, locals: { model.class.name.underscore.to_sym => model }, status: :unprocessable_entity }
        format.json { render json: model.errors, status: :unprocessable_entity }
      end
    end
  end

  def generic_update(model, model_params, redirect_action: :index)
    respond_to do |format|
      if model.update(model_params)
        format.html { redirect_to redirect_url_for_action(model, redirect_action), notice: "#{model.class} was successfully updated." }
        format.json { render :show, status: :ok, location: model }
      else
        flash[:error] = model.errors.full_messages.join(', ')
        format.html { render :edit, locals: { model.class.name.underscore.to_sym => model }, status: :unprocessable_entity }
        format.json { render json: model.errors, status: :unprocessable_entity }
      end
    end
  end

  def generic_destroy(model)
    model.destroy!

    respond_to do |format|
      format.html { redirect_to redirect_url_for_action(model, :index), status: :see_other, notice: "#{model.class} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def redirect_url_for_action(model, action)
    return url_for(controller: model.model_name.route_key, action: :index) if action == :index

    url_for(model)
  end
end
