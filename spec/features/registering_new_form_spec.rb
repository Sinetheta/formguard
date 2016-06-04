require "rails_helper"

RSpec.feature "Form creation", :type => :feature do
  let(:user) { create(:user) }
  let(:action) { build(:form_action, :with_mailing_list ) }
  scenario "User creates a from with two extra emails to notify", js: true do
    sign_up_with('user@example.com', 'password')
    visit form_actions_path

    fill_in "Name", with: action.name
    all(".mailing-list").last.set("one@example.com")
    all(".mailing-list").last.set("two@example.com")

    click_on "Create Form"

    page.assert_selector("li", :text => "user@example.com")
    page.assert_selector("li", :text => "one@example.com")
    page.assert_selector("li", :text => "two@example.com")

    click_on "Logout"
  end

  scenario "User submits duplicates to mailing-list", js: true do
    sign_up_with('new_user@example.com', 'password')

    visit form_actions_path

    fill_in "Name", with: 'Duplicate emails'
    all(".mailing-list").last.set("one@example.com")
    all(".mailing-list").last.set("two@example.com")

    click_on "Create Form"

    page.assert_selector("li", :text => "one@example.com", count: 1)
  end

end
