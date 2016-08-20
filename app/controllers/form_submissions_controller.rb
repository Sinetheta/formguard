class FormSubmissionsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :load_form_action

  def create
    submission = @form_action.form_submissions.new(payload: payload)
    authorize! :create, FormSubmission
    file = attachment
    if file
      submission.attachment = file.read
      submission.attachment_name = File.basename(file.original_filename)
      submission.attachment_type = file.content_type
    end
    if submission.save
      UserMailer.submission_notification(submission).deliver_now if @form_action.should_notify?
      AutoResponseMailer.submission_notification(@form_action, submission).deliver_now if @form_action.auto_response
      @form_action.web_hook_dispatcher.deliver(:submission, payload.to_json)
      head 200
    else
      head 422
    end
  end

  def update
    load_form_submission
    authorize! :update, @form_submission
    @form_submission.update_attribute(:read, true)
    render :show
  end

  def download_attachment
    load_form_submission
    authorize! :download_attachment, @form_submission
    send_data(@form_submission.attachment,
              type: @form_submission.attachment_type,
              name: @form_submission.attachment_name)
  end

  private

  def load_form_action
    @form_action = FormAction.find(params[:form_action_id])
  end

  def load_form_submission
    @form_submission = FormSubmission.find(params[:id])
  end

  def payload
    params.except(:controller,
                  :action,
                  :form_action_id,
                  :authenticity_token,
                  :utf8,
                  :commit).select{ |k, v| v.class == String }
  end

  def attachment
    params.flatten.detect { |item| item.class == ActionDispatch::Http::UploadedFile }
  end
end
