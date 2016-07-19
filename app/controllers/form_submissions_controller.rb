class FormSubmissionsController < ApplicationController
  protect_from_forgery with: :null_session
  load_and_authorize_resource

  def create
    form_action = FormAction.find(params[:form_action_id])
    submission = form_action.form_submissions.new(payload: payload)
    if submission.save
      UserMailer.submission_notification(submission).deliver_now if form_action.should_notify?
      AutoResponseMailer.submission_notification(form_action, submission).deliver_now if form_action.auto_response
      form_action.web_hook_dispatcher.deliver(:submission, payload.to_json)
      head 200
    else
      head 500
    end
  end

  def update
    @form_submission.update_attribute(:read, true)
    render :show
  end

  private

  def payload
    params.except(:controller, :action, :form_action_id, :authenticity_token, :utf8, :commit)
  end
end
