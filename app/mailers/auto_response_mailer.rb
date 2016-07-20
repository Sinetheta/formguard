class AutoResponseMailer < ApplicationMailer

  def submission_notification(form_action, submission)
    @response_message = form_action.auto_response
    @email = submission.payload["email"]
    mail(to: @email, subject: "We've received your submission!")
  end

end
