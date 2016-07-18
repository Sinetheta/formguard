require 'rails_helper'

RSpec.describe InviteMailer, type: :mailer do
  let(:invite) { create :invite }

  describe 'inviting a new user' do
    subject(:invite_new) { InviteMailer.new_user_invite(invite) }

    it 'sends email from the correct address' do
      expect(invite_new.from).to eq(["noreply@stembolt.com"])
    end

    it 'sends email to the correct address' do
      expect(invite_new.to).to include(invite.email)
    end

    it 'has the correct subject' do
      expect(invite_new.subject).to eq("Join us at Formguard")
    end
  end
  
  describe 'inviting an existing user' do
    let(:recipient) { create :user }
    let(:sender) { create :user }
    let(:team) { create :team }
    let(:existing_user_invite) { create :invite, sender: sender, recipient: recipient, team: team }
    subject(:invite_existing) { InviteMailer.existing_user_invite(existing_user_invite) }

    it 'has the correct subject' do
      expect(invite_existing.subject).to eq("Formguard Team Invite")
    end
  end
end
