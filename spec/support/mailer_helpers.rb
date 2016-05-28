module MailerHelpers
  def emails
    ActionMailers::Base.deliveries
  end

  def last_email
    emails.last
  end
end
