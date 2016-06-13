require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "UserMailer #submission_notification" do

    context "notifications enabled" do
      let(:user) { create(:user) }
      let(:action) { create(:form_action, :notification_enabled, user: user) }
      let(:submission_with_payload) { create(:form_submission, :with_payload, form_action: action) }

      subject(:user_mail) { UserMailer.submission_notification(submission_with_payload) }

      it "sends email from the correct address" do
        expect(user_mail.from).to eq(["noreply@stembolt.com"])
      end

      it "has the correct subject" do
        expect(user_mail.subject).to eq("Submission notification")
      end

      it "sends email to the entire mailing list" do
        expect(user_mail.bcc).to eq(submission_with_payload.form_action.emails)
      end

      it "sends the correct payload" do
        expect(user_mail.body.encoded).to include("key1", "value1", "key2", "value2")
      end
    end
  end
end
