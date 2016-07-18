require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:sender) { create(:user) }
  let(:team) { create(:team) }
  let(:invite) { create(:invite, sender: sender, recipient: nil, team: team, email: "newguy@google.ca") }

  describe "#create" do
    subject(:create_user) { post :create, user: user_params }
    context "with valid params and invite token" do
      let(:user_params) do
        { 
          email: invite.email,
          password: 'mikemike',
          password_confirmation: 'mikemike',
          invite_token: invite.token 
        }
      end 
        
      it "creates a new user and add them to the token team" do
        create_user
        expect(User.find_by(email: invite.email).teams).to include(team)
      end
    end

    context "without valid params or token" do
      let(:user_params) { { email: "invalid" } }

      it "does not create a new user" do
        expect{ subject }.to change(User, :count).by(0)
      end
    end
  end

end
