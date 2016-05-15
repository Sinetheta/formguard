class FormActionsController < ApplicationController
  def index
    @form_actions = current_user.form_actions
  end

  def show
    @form_action = FormAction.find(params[:id])
  end
end
