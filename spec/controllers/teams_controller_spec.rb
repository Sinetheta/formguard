require 'rails_helper'
require 'cancan/matchers'

RSpec.describe TeamsController, type: :controller do
  let(:creator) { create(:user) }
  let(:owner) { create(:user) }
  let(:team) { create(:team, members: [owner]) }
  
  before { owner.add_role(:owner, team) } 

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
end
