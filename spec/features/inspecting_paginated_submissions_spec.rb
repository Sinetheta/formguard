require "rails_helper"

RSpec.feature "Paginated form submissions", :type => :feature do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user ) }
  before do
    create_list(:form_submission, 2, form_action: action)
  end

  scenario "User inspects form with paginated submissions", js: true do
    sign_in(user)
    visit "/forms/#{action.id}?page=1&per_page=1"
    page.assert_selector("li.submission", count: 1)
    first("ul.pagination.pagination").click_link("2")
    page.assert_selector("li.submission", count: 1)
  end
end
