require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }
  let!(:team) { create(:team, members: [user]) }
  let(:form) { create(:form_action, team: team) }
  let(:membership) { create(:membership, team: team, member: user) } 
  let(:invite) { Invite.new(team: team, sender: user, recipient: recipient) }
  let(:ability) { Ability.new(user) }

  context "when team member" do
    it "has read access" do
      expect(ability).to be_able_to(:read, team)
    end

    it "cannot invite other users to join team" do
      expect(ability).to_not be_able_to(:create, invite)
    end

    it "can manage their own memberships" do
      expect(ability).to be_able_to(:destroy, membership)
    end

    it "can read a team's forms" do
      expect(ability).to be_able_to(:read, form)
    end

    it "can access the form embed page" do
      expect(ability).to be_able_to(:embed, form)
    end
  end

  context "when team admin" do
    before { user.add_role(:admin, team) }

    it "can delete other team members" do
      expect(ability).to be_able_to(:destroy, membership)
    end

    context "when inviting users" do
      it "can invite other users to join" do
        expect(ability).to be_able_to(:create, invite)
      end
    end
  end
  
  context "when team owner" do
    before { user.add_role(:owner, team) }

    it "can manage team" do
      expect(ability).to be_able_to(:manage, team)
    end
  end
end
