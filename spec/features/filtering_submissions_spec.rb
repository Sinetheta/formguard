require "rails_helper"

RSpec.feature "Form submission filtering", type: :feature do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user) }

  before do
    (1..5).each do |x|
      create_list(:form_submission, 2, form_action: action, created_at: "2000-#{x}-#{x}")
      create_list(:form_submission, 3, form_action: action, created_at: "2000-#{x}-#{x}", read: true)
    end
  end

  before(:each) do
    sign_in(user)
    visit "/forms/#{action.id}"
  end

  context "User views both read and unread submissions" do
    scenario "User filters dates with a negative date window" do
      fill_in("q", with: "from:2000-1-1 to:1999-1-1")
      click_button("Filter!")
      page.assert_selector(".alert.alert-danger", count:1)
      page.has_text?("'Until' date must come after 'From' date", count: 1)
    end

    scenario "User filters by end-date to show only 5 submissions" do
      fill_in("q", with: "to:2000-1-1")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 5)
    end

    scenario "User filters by start-date to show only 5 submissions" do
      fill_in("q", with: "from:2000-5-5")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 5)
    end

    scenario "User filters by start and end dates to show 10 submissions" do
      fill_in("q", with: "from:2000-3-3 to:2000-4-4")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 10)
    end
  end

  context "User views only unread submissions" do
    scenario "User date filters dates with a negative date window" do
      fill_in("q", with: "from:2000-1-1 to:1999-1-1 status:unread")
      click_button("Filter!")
      page.assert_selector(".alert.alert-danger", count:1)
      page.has_text?("'Until' date must come after 'From' date", count: 1)
    end

    scenario "User date filters by end-date to show only 2 submissions" do
      fill_in("q", with: "to:2000-1-1 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 2)
    end

    scenario "User date filters by start-date to show only 2 submissions" do
      fill_in("q", with: "from:2000-5-5 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 2)
    end

    scenario "User date filters by start and end dates to show 4 submissions" do
    fill_in("q", with: "from:2000-3-3 to:2000-4-4 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 4)
    end
  end

  context "User views only read submissions" do
    scenario "User date filters dates with a negative date window" do
      fill_in("q", with: "from:2000-1-1 to:1999-1-1 status:read")
      click_button("Filter!")
      page.assert_selector(".alert.alert-danger", count:1)
      page.has_text?("'Until' date must come after 'From' date", count: 1)
    end

    scenario "User date filters by end-date to show only 3 submissions" do
      fill_in("q", with: "to:2000-1-1 status:read")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 3)
    end

    scenario "User date filters by start-date to show only 3 submissions" do
      fill_in("q", with: "from:2000-5-5 status:read")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 3)
    end

    scenario "User date filters by start and end dates to show 6 submissions" do
      fill_in("q", with: "from:2000-3-3 to:2000-4-4 status:read")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 6)
    end
  end

  context "User views only unread submissions" do
    scenario "User date filters dates with a negative date window" do
      fill_in("q", with: "from:2000-1-1 to:1999-1-1 status:unread")
      click_button("Filter!")
      page.assert_selector(".alert.alert-danger", count:1)
      page.has_text?("'Until' date must come after 'From' date", count: 1)
    end

    scenario "User date filters by end-date to show only 5 submissions" do
      fill_in("q", with: "to:2000-1-1 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 2)
    end

    scenario "User date filters by start-date to show only 5 submissions" do
      fill_in("q", with: "from:2000-5-5 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 2)
    end

    scenario "User date filters by start and end dates to show 10 submissions" do
    fill_in("q", with: "from:2000-3-3 to:2000-4-4 status:unread")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 4)
    end
  end

  scenario "User submits an empty date filter to receive all submissions" do
    click_button("Filter!")
    page.assert_selector("li.submission", count: 25)
  end

  scenario "User submits an unsupported status" do
      fill_in("q", with: "to:2000-1-1 status:unsupported")
      click_button("Filter!")
      page.assert_selector("li.submission", count: 5)
  end
end
