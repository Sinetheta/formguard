class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.submission_notification.subject
  #
  def submission_notification(submission)
    @submission = submission
    @action = submission.form_action
    @user = @action.user
    @greeting = "Hi there,\n#{@user.email} asked that you be notified!"
    mail(bcc: @action.emails, subject: "Submission notification")
  end
end
