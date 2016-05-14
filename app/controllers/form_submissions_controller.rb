class FormSubmissionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    form_action = FormAction.find(params[:form_action_id])
    submission = form_action.form_submissions.new({payload: payload})
    if submission.save
      head :ok
    else
      head 500
    end
  end

  private

  def payload
    params.except(:controller, :action, :form_action_id)
  end
end
