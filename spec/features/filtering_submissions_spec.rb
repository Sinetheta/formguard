require "rails_helper"

RSpec.feature "Form submission filtering", type: :feature do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user) }

  before do
    (1..5).each do |x|
      create_list(:form_submission, 5, form_action: action, created_at: "2000-#{x}-#{x}")
    end
  end

  before(:each) do
    sign_in(user)
    visit "/forms/#{action.id}"
  end

  scenario "User filters dates with a negative date window" do
    fill_in("start_date", with: "2000-1-1")
    fill_in("end_date", with: "1999-1-1")
    click_button("Filter!")
    page.assert_selector(".alert.alert-danger", count:1)
    page.has_text?("'Until' date must come after 'From' date", count: 1)
  end

  scenario "User filters by end-date to show only 5 submissions" do
    fill_in("end_date", with: "2000-1-1")
    click_button("Filter!")
    page.assert_selector("li.submission", count: 5)
  end

  scenario "User filters by start-date to show only 5 submissions" do
    fill_in("start_date", with: "2000-5-5")
    click_button("Filter!")
    page.assert_selector("li.submission", count: 5)
  end

  scenario "User filters by start and end dates to show 10 submissions" do
    fill_in("start_date", with: "2000-3-3")
    fill_in("end_date", with: "2000-4-4")
    click_button("Filter!")
    page.assert_selector("li.submission", count: 10)
  end

  scenario "User submits and empty filter to receive all submissions" do
    click_button("Filter!")
    page.assert_selector("li.submission", count: 25)
  end
end
