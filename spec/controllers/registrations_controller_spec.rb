require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:sender) { create(:user) }
  let(:team) { create(:team) }
  let(:invite) { create(:invite, sender: sender, recipient: nil, team: team, email: "newguy@exampl.com") }

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
        expect{ create_user }.to change(User, :count).by(0)
      end
    end
  end

  describe "#update" do
    subject(:update_user) { patch :update, id: @user, user: update_params }

    before :each do
      @user = create(:user, email: 'old@example.com')
      sign_in @user
    end
    
    context "with valid attributes" do
      let(:update_params) { { email: 'new@example.com', current_password: 'password' } }

      it "updates user attributes" do
        update_user
        expect(@user.reload.email).to eq('new@example.com')
      end
    end

    context "without valid attributes" do
      let(:update_params) { { email: 'invalid', current_password: 'password' } }

      it "does not update" do
        expect(@user.reload.email).to eq('old@example.com')
      end
    end
  end

end
