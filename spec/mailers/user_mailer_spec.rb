require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  context "notifying form owner of new submission" do
    let(:submission_with_payload) { build(:form_submission, :with_payload) }

    subject(:user_mail) { UserMailer.submission_notification(submission_with_payload) }

    it "sends email from the correct address" do
      expect(user_mail.from).to eq(["noreply@stembolt.com"])
    end

    it "has the correct subject" do
      expect(user_mail.subject).to eq("Submission notification")
    end

    it "sends email to the correct user" do
      expect(user_mail.to).to eq([submission_with_payload.form_action.user.email])
    end

    it "uses the correct target address" do
      expect(user_mail.body.encoded).to include(submission_with_payload.form_action.user.email)
    end

    it "sends the correct payload" do
      expect(user_mail.body.encoded).to include("key1", "value1", "key2", "value2")
    end
  end

end
