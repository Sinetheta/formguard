require 'rails_helper'

RSpec.describe Invite, type: :model do
  let(:user) { create :user }
  let(:team) { create :team } 
  let(:invite) { create :invite, sender: user, team: team }

  describe "creating an invite" do
    it 'creates an invite token' do
      expect(invite.token).not_to be_nil
    end
  end
end
