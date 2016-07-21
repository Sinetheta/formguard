require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:user) { create(:user) }
  let(:team) { create(:team) } 

  describe "adding a user to a team" do
    before { team.members << user } 
    
    it "creates a membership" do
      expect(user.memberships).to_not be_empty
    end

    it "creates a membership with the correct team" do
      expect(user.memberships.first.team).to eq(team)
    end

    context "when user is an admin" do
      before { user.add_role :admin, team } 

      it "responds to #admin?" do
        expect(user.memberships.first.admin?).to be true
      end
    end
  end
end
