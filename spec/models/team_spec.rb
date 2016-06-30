require 'rails_helper'

RSpec.describe Team, type: :model do

  let(:team) { create(:team) } 
  let(:user) { create(:user) }

  it { is_expected.to have_many(:users) }
  
  it { is_expected.to have_many(:form_actions) } 

  it "can delete users" do
    team.users << user
    team.users.delete user
    expect(team.users).to be_empty
  end
    
end
