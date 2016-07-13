require 'rails_helper'
require 'cancan/matchers'

RSpec.describe TeamsController, type: :controller do
  let(:creator) { create(:user) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:admin) { create(:user) }
  let(:team) { create(:team, members: [owner, member, admin]) }
  
  before do 
    owner.add_role(:owner, team)  
    admin.add_role(:admin, team)
  end

  describe "#create" do
    before do
      allow(controller).to receive(:current_user) { creator }
      post :create, team: { name: "created_team" }
      @created_team = Team.find_by_name("created_team")
    end

    it "new team should belong to the creator" do
      expect(@created_team.owner).to eq creator
    end

    it "owner should also have admin capabilities" do
      expect(creator.has_role?(:admin, @created_team)).to be_truthy
    end
  end

  describe "#delete" do
    subject { delete :destroy, id: team.id }

    context "when current_user is not owner" do
      it "should not delete the team" do
        subject
        expect(team).to be_present 
      end
    end

    context "when current_user is owner" do
      before { allow(controller).to receive(:current_user) { owner } }
      it "should delete the team" do
        expect{ subject }.to change(Team, :count).by(-1)
      end

      context "when delete fails" do
        before { allow_any_instance_of(Team).to receive(:destroy).and_return(false) }
        it "returns a flash error message" do
          expect{ subject }.to change(Team, :count).by(0)
          expect(controller).to set_flash[:error]
        end
      end
    end
  end

  describe "POST #grant_ownership" do
    subject { post :grant_ownership, id: team.id, user_id: member.id }

    context "when current_user is not owner" do
      it "should not transfer ownership" do
        subject
        expect(team.owner).to eq owner
      end
    end

    context "when current_user is owner" do
      before { allow(controller).to receive(:current_user) { owner } }

      it "should transfer ownership to the specified member" do
        subject
        expect(team.owner).to eq member
      end

      it "should remove current_user as owner" do
        subject
        expect(owner.has_role?(:owner, team)).to be_falsey
      end
    end
  end

  describe "POST #make_admin" do
    subject { post :make_admin, id: team.id, user_id: member.id }

    context "when current_user is not admin" do
      it "should not make user an admin" do
        subject
        expect(member.in? team.admins).to be_falsey
      end
    end

    context "when current_user is admin" do
      before { allow(controller).to receive(:current_user) { admin } }

      it "should make selected member an admin" do
        subject
        expect(member.has_role?(:admin, team)).to be_truthy
      end
    end
  end

  describe "POST #remove_admin" do
    subject { post :remove_admin, id: team.id, user_id: member.id }
    before { member.add_role(:admin, team) }

    context "when current_user is not admin" do
      it "should not revoke admin status" do
        subject
        expect(member.in? team.admins).to be_truthy
      end
    end

    context "when current_user is an admin" do
      before { allow(controller).to receive(:current_user) { admin } }

      it "remove selected member's admin status" do
        subject
        expect(member.in? team.admins).to be_falsey
      end
    end
  end
end
