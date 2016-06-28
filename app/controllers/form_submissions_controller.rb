class FormSubmissionsController < ApplicationController
  protect_from_forgery with: :null_session
  load_and_authorize_resource

  def create
    form_action = FormAction.find(params[:form_action_id])
    submission = form_action.form_submissions.new(payload: payload)
    if submission.save
      UserMailer.submission_notification(submission).deliver_now if form_action.should_notify?
      redirect_to form_action_path(form_action)
    else
      head 500
    end
  end

  private

  def payload
    params.except(:controller, :action, :form_action_id, :authenticity_token, :utf8, :commit)
  end
end
