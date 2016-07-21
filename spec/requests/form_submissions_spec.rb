require "rails_helper"

RSpec.describe "FormSubmission reading", type: :request do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user ) }
  let(:submission) { create(:form_submission, :with_payload, form_action: action) }

  let(:other_user) { create(:user) }
  let(:other_action) { create(:form_action, user: other_user) }
  let(:other_submission) { create(:form_submission, :with_payload, form_action: other_action) }

  describe "PUT form_action#update" do
    context "when user signed in" do
      before { login_as(user) }

      context "when submission-form is owned by user" do
        subject { put "/submissions/#{submission.id}" }

        it { is_expected.to eq(200) }

        it "updates read/unread status" do
          expect { subject }.to change { submission.reload.read }.from(false).to(true)
        end
      end

      context "when submission-form is not owned by user" do
        subject { put "/submissions/#{other_submission.id}" }

        it { is_expected.to eq(302) }
      end
    end
    context "when user not signed in" do
      before { logout(user) }
      subject { put "/submissions/#{submission.id}" }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

end

RSpec.describe "FormSubmission creation", type: :request do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user ) }

  describe "POST form_submission#create" do
    subject {
      post "/forms/#{action.id}/s",
      attachment: fixture_file_upload('spec/fixtures/form_submission/attachments/test.txt', 'text/plain')
    }

    it { is_expected.to eq(200) }

    it "creates a new submission" do
      expect { subject }.to change(FormSubmission, :count).by(1)
    end

    it "adds an attachment to the submission" do
      subject
      expect( action.reload.form_submissions.last.attachment_name ).to eq("test.txt")
    end
  end
end
