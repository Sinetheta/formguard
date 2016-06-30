require "rails_helper"

RSpec.describe "Web hooks", type: :request do

  let(:user) { create(:user) }
  let(:action) { create(:form_action, :with_mailing_list, user: user) }

  context "when hook is associated with a form action" do

    let (:submission) { {key: "value"} }

    let (:web_hook) { create(:web_hook, :valid, :on_form) }

    describe "POST form_submission#create" do
      subject { post "/forms/#{web_hook.webhookable.id}/s", submission }

      before { stub_request(:post, "http://www.example.com") }

      before(:each) do
        subject
      end

      it "triggers a web hook" do
        expect(a_request(:post, "http://www.example.com")).to have_been_made.once
      end

      it "delivers the correct payload" do
        expect(a_request(:post, "http://www.example.com").
               with(body: submission)).to have_been_made
      end

      it "uses the correct header" do
        expect(a_request(:post, "http://www.example.com").
               with(headers: {'Content-Type' => 'application/json'})).to have_been_made
      end
    end

    describe "GET web_hook#index" do
      subject { get "/forms/#{web_hook.webhookable.id}/web_hooks" }

      context "when user signed in" do
        before { login_as(user) }

        it { is_expected.to eq(200) }
        it { is_expected.to render_template("index") }
      end
      context "when user not signed in" do
        before { logout(user) }

        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end

    describe "GET web_hook#show" do
      subject { get "/forms/#{web_hook.webhookable.id}/web_hooks/#{web_hook.id}" }

      context "when user signed in" do
        before { login_as(user) }

        it { is_expected.to eq(200) }
        it { is_expected.to render_template("show") }
      end

      context "when user not signed in" do
        before { logout(user) }
        it { is_expected.to redirect_to(new_user_session_path) }
      end
    end

    describe "POST web_hook#create" do
      context "with valid attributes" do
        let(:valid_attributes) {
          {"web_hook"=>{"event_type"=>"submission", "url"=>"http://www.example.com"}}
        }

        subject { post "/forms/#{action.id}/web_hooks", valid_attributes }

        context "when user signed in" do
          before { login_as(user) }
          it "creates a new WebHook" do
            expect{ subject }.to change(WebHook, :count).by(1)
          end
        end

        context "when user not signed in" do
          before { logout(user) }
          it { is_expected.to redirect_to(new_user_session_path) }
          it { is_expected.to eq(302) }
        end
      end
      context "with invalid attributes" do
        let(:invalid_attributes) {
          {"web_hook"=>{"event_type"=>"submission", "url"=>""}}
        }
        subject { post "/forms/#{action.id}/web_hooks", invalid_attributes }

        context "when user signed in" do
          before { login_as(user) }
          it "doesn't create a new WebHook" do
            expect{ subject }.to change(WebHook, :count).by(0)
          end
          it { is_expected.to render_template("web_hooks/new") }
        end

        context "when user not signed in" do
          before { logout(user) }
          it { is_expected.to redirect_to(new_user_session_path) }
          it { is_expected.to eq(302) }
        end
      end
    end

    describe "GET web_hook#new" do
      subject { get "/forms/#{action.id}/web_hooks/new" }
      context"when user signed in" do
        before { login_as(user) }

        it { is_expected.to eq(200) }
        it { is_expected.to render_template("new") }

      end
      context "when user not signed in" do
        before { logout(user) }
        it { is_expected.to redirect_to(new_user_session_path) }
        it { is_expected.to eq(302) }
      end
    end

  end

  context "when hook is watching something else", pending: "web hooks on other models implemented" do
  end
end
