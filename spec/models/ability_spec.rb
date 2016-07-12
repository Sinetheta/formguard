require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let(:user) { create(:user) }
  let(:team) { create(:team, members: [user]) }
  let(:admin) { create(:user) }

  context "when team member" do
    it "has read access" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, team)
    end
  end

  context "when team admin" do
    let(:membership) { create(:membership, team_id: team.id) }
    before { user.add_role(:admin, team) }

    it "can delete other team members" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:destroy, membership)
    end
  end
  
  context "when team owner" do
    before { user.add_role(:owner, team) }

    it "can manage team" do
      ability = Ability.new(user)
      expect(ability).to be_able_to(:manage, team)
    end
  end
end
