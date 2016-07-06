require "rails_helper"

RSpec.feature "Form editing", type: :feature do

  let (:user) { build(:user) }
  before {
    sign_up_with(user.email, user.password)
    sign_out
  }

  scenario "User modifies a form's mailing list", js: true do

    while_signed_in_as(user) do
      visit new_form_action_path

      fill_in "Name", with: "Example Form"
      all(".mailing-list").last.set("one@example.com")
      all(".mailing-list").last.set("two@example.com")

      click_on "Create Form"
      click_on "Edit"

      all(".mailing-list").first.set("new_address@example.com")


      click_on "Save changes"

      page.assert_selector("li", text: "new_address@example.com", count:1)
      page.assert_selector("li", text: "one@example.com", count:1)
      page.assert_selector("li", text: "two@example.com", count:1)
      page.assert_selector("li", text: user.email, count:0)
    end

  end

  scenario "User modifies a form's mailing list with a malformed email", js: true do

    while_signed_in_as(user) do
      visit new_form_action_path

      fill_in "Name", with: "Example Form"
      all(".mailing-list").last.set("one@example.com")
      all(".mailing-list").last.set("two@example.com")

      click_on "Create Form"
      click_on "Edit"

      all(".mailing-list").first.set("malformed-email")


      click_on "Save changes"

      page.assert_selector("li", text: "malformed-email", count:0)
    end
  end
end
