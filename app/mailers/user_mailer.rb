class UserMailer < ApplicationMailer

  class SubmissionMessage
    attr_reader :email, :action, :content, :user, :bcc_list, :payload

    def initialize(submission)
      @action = submission.form_action
      @email = submission.payload["email"]
      @content = submission.payload.except("email")
      @user = @action.user
      @bcc_list = @action.emails
      @payload = submission.payload
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.submission_notification.subject
  #
  
  def submission_notification(submission)
    @message = SubmissionMessage.new(submission)
    mail(bcc: @message.bcc_list, subject: "Submission notification")
  end
end
