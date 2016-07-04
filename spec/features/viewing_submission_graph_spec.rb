require "rails_helper"

RSpec.feature "Form submissions graph", :type => :feature do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user) }

  before do
    (1..5).each do  |index|
      create_list(:form_submission, index, form_action: action, created_at: "2000-01-#{index}")
    end
  end

  scenario "User views form-submission graph", js: true do
    d_path = /M0,460L222.5,345L445,230L667.5,115L890,0/

    sign_in(user)
    visit "/forms/#{action.id}"
    path = page.find('path.line')[:d]
    expect(path).to match(Regexp.new(d_path))
  end
end
