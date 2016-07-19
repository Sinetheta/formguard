require "rails_helper"

RSpec.describe FormSubmissionsController, type: :controller do
  describe "POST #create" do

    let(:user) { create(:user) }

    context "with a valid submission" do
      subject { post :create, { "test"=>"data", "form_action_id"=>action.id} }
      let(:action) { create(:form_action, user: user) }

      it "should save the submission" do
        expect{ subject }.to change { FormSubmission.count }.by(1)
      end

      it "should return code 200" do
        expect(subject.code).to eq("200")
      end

      it "should exclude values from payload" do
        subject
        expect(FormSubmission.last.payload.keys).to contain_exactly("test")
      end

      context "on a notification-disabled form" do

        it "should not send a notification email." do
          expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end

      context "on a notification-enabled form" do
        let(:action) { create(:form_action, :notification_enabled, :with_mailing_list, user: user) }

        it "should send a notification email." do
          expect{ subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when an autoresponse is provided" do
        let(:action) { create(:form_action, auto_response: 'response', user: user) }
        subject { post :create, form_action_id: action.id, email: "email@example.com", content: "content" }

        it "sends a response to the submitter" do
          expect{ subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when save fails" do
        before(:each) { allow_any_instance_of(FormSubmission).to receive(:save).and_return(false) }
        it "should return code 500" do
          expect(subject.code).to eq("500")
        end

      end
    end

  end

end
