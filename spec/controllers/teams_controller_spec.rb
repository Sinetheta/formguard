require 'rails_helper'
require 'cancan/matchers'

RSpec.describe TeamsController, type: :controller do
  let(:creator) { create(:user) }

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
end
