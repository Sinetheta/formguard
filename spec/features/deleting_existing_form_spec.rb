require "rails_helper"

RSpec.feature "Form destroying", type: :feature do

  let (:user) { build(:user) }
  before {
    sign_up_with(user.email, user.password)
    sign_out
  }

  scenario "User deletes an existing form", js: true do
    while_signed_in_as(user) do

      visit new_form_action_path

      fill_in "Name", with: "Example Form"
      all(".mailing-list").last.set("one@example.com")
      all(".mailing-list").last.set("two@example.com")

      click_on "Create Form"

      page.accept_confirm { click_link("Delete") }

      page.assert_selector("li", text: "Example Form", count: 0)

    end
  end
end
