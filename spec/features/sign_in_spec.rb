require "rails_helper"

RSpec.feature "User signs in", :type => :feature do
  let(:user) { create(:user) }

  scenario "User with account signs in", js: true do
    sign_in(user)
    page.assert_text("Signed in successfully")
  end

end
