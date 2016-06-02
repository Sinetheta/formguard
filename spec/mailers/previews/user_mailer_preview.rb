# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/submission_notification
  def submission_notification
    submission = FormSubmission.first
    UserMailer.submission_notification(submission)
  end

end
