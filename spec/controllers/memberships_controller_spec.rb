require 'rails_helper'
require 'cancan/matchers'

RSpec.describe MembershipsController, type: :controller do
  let(:admin) { create(:user) }
  let(:member) { create(:user) }
  let(:team) { create(:team, members: [member, admin]) }

  before { admin.add_role(:admin, team) }

  describe "#destroy" do
    subject { delete :destroy, 
              id: member.memberships.first.id, 
              team_id: member.memberships.first.team_id }

    context "when current_user is not admin" do
      it "should not remove selected member" do
        expect{ subject }.to change(team.members, :count).by(0)
      end
    end

    context "when current_user is an admin" do
      before { allow(controller).to receive(:current_user) { admin } }

      it "should remove selected member" do
        expect{ subject }.to change(team.members, :count).by(-1)
      end

      context "and they try to kill themself" do
        it "doesn't let them kill themself" do
          delete :destroy,
            id: admin.memberships.first.id
          expect{ subject }.to change(team.members, :count).by(0)
        end
      end
    end

    context "when current_user is team owner" do
      before do 
        allow(controller).to receive(:current_user) { member }
        member.add_role(:owner, team)
      end

      it "warns user to transfer team ownership first" do
        delete :destroy, id: member.memberships.first.id
        expect(team.owner).to eq member
      end
    end
  end
end
