require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }
  let(:team) { create(:team) }  
  let(:invite_params) { { team_id: team } }

  describe "POST #create" do
    subject(:create_invite) { post :create, invite: invite_params, emails: email_params }

    context "when user is an admin" do

      before do 
        user.add_role :admin, team
        allow(controller).to receive(:current_user) { user } 
      end

      context "to a new user" do
        context "with a valid email" do
          let(:email_params) { ["new_user@example.com"] }
          
          it "creates an invite" do
            expect{ create_invite }.to change(Invite, :count).by(1)
          end
        end

        context "without a valid email" do
          let(:email_params) { ["invalid"] }

          it "does not create an invite" do
            expect{ create_invite }.to change(Invite, :count).by(0)
          end
        end
      end

      context "to an existing user" do
        let(:email_params) { [recipient.email] }

        it "creates an invite" do
          expect{ create_invite }.to change(Invite, :count).by(1)
        end

        it "adds the user to the current_user's team" do
          expect { create_invite }.to change(team.members, :count).by(1)
        end
      end
    end 

    context "when user is not admin" do
      let(:email_params) { ["new_user@example.com"] }
      before{ allow(controller).to receive(:current_user) { user } }

      it "does not create an invite" do
        expect{ create_invite }.to change(Invite, :count).by(0)
      end
    end
  end

end
