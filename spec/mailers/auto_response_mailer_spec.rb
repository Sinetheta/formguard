require "rails_helper"

RSpec.describe AutoResponseMailer, type: :mailer do
  let(:form_action) { FormAction.new(auto_response: "response text") }
  let(:submission) { form_action.form_submissions.new(payload: { email: "email@example.com", content: "stuff" }) }

  describe 'after submitting a form' do

    context 'when auto_response is present' do
      subject(:response_email) { AutoResponseMailer.submission_notification(form_action, submission).deliver_now }

      it 'sends email from the correct address' do
        expect(response_email.from).to eq(["noreply@stembolt.com"])
      end

      it 'sends email to the correct address' do
        expect(response_email.to).to eq(["email@example.com"])
      end

      it 'sends an email with the correct subject' do
        expect(response_email.subject).to eq("We've received your submission!")
      end
    end
  end
end
