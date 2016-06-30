require 'rails_helper'

RSpec.describe User, type: :model do

  let(:team) { create(:team) } 
  let(:user) { create(:user) }
  let(:other_team) { create(:team) }

  it { is_expected.to have_many(:form_actions) }
  
  it "can belong to more than one team" do
    team.members << user
    other_team.members << user
    expect(user.teams.length).to eq(2)
  end
   
end
