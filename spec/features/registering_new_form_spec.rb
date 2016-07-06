require "rails_helper"

RSpec.feature "Form creation", :type => :feature do
  let (:user) { build(:user) }
  let (:action) { build(:form_action, :with_mailing_list) }
  before {
    sign_up_with(user.email, user.password)
    sign_out
  }

  scenario "User creates a from with two extra emails to notify", js: true do
    while_signed_in_as(user) do
      visit new_form_action_path

      fill_in "Name", with: action.name
      all(".mailing-list").last.set("one@example.com")
      all(".mailing-list").last.set("two@example.com")

      click_on "Create Form"

      page.assert_selector("li", :text => user.email)
      page.assert_selector("li", :text => "one@example.com")
      page.assert_selector("li", :text => "two@example.com")
    end
  end

  scenario "User submits duplicates to mailing-list", js: true do
    while_signed_in_as(user) do
      visit new_form_action_path

      fill_in "Name", with: 'Duplicate emails'
      all(".mailing-list").last.set("one@example.com")
      all(".mailing-list").last.set("two@example.com")

      click_on "Create Form"

      page.assert_selector("li", :text => "one@example.com", count: 1)
    end
  end

end
