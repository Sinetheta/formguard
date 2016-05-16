class FormActionsController < ApplicationController
  def index
    @form_actions = current_user.form_actions
  end

  def show
    @form_action = FormAction.find(params[:id])
  end

  def create
    @form_action = current_user.form_actions.new(form_action_params)
    @form_action.user_id = current_user.id if current_user
    if @form_action.save
      redirect_to @form_action
    else
      render "index"
    end
  end
end
