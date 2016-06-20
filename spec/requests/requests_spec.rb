require "rails_helper"

RSpec.describe "Form creation", type: :request do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, :with_mailing_list, user: user) }

  describe "POST form_action#create" do
    context "when user signed in" do
      before { login_as(user) }

      context "with valid params" do
        let(:valid_attributes) { {emails: action.emails, form_action:{name:action.name,
                                                                      should_notify: "1"}} }
        subject { post "/forms", valid_attributes }

        it "creates a new FormAction" do
          expect { subject }.to change(FormAction, :count).by(1)
        end
      end
    end

    context "when user not signed in"do
      before { logout(user) }

      context "with valid params" do
        let(:valid_attributes) { {emails: action.emails, form_action:{name:action.name,
                                                                      should_notify: "1"}} }
        subject { post "/forms", valid_attributes }

        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end


  describe "GET form_action#index" do
    subject { get "/forms" }

    context "when user signed in" do
      before { login_as(user) }

      it "returns a 200 status code" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "when user not signed in"do
      before { logout(user) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end


  describe "GET form_action#show" do
    subject { get "/forms/#{action.id}" }

    context "when user signed in" do
      before { login_as(user) }
      it { is_expected.to render_template("show") }
    end

    context "when user not signed in"do
      before { logout(user) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "denies access to other user's data"do
    let(:other_user) { create(:user) }

    context "when accessing form_action_path" do
      subject { get "/forms/#{action.id}" }

      context "when user signed in" do
        before { login_as(other_user) }
        it { is_expected.to redirect_to(authenticated_root_path) }
      end

      context "when user not signed in" do
        before do
          logout(other_user)
          logout(user)
        end
        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end

    context "when accessing form_actions_path" do
      subject { get "/forms" }

      context "when user signed in" do
        before { login_as(other_user) }

        it "returns a 200 status code" do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context "when user not signed in" do
        before do
          logout(other_user)
          logout(user)
        end
        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end
  end

end
