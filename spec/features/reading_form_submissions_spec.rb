require "rails_helper"

RSpec.feature "Form submissions read/unread status", type: :feature do
  let(:user) { create(:user) }
  let(:action) { create(:form_action, user: user ) }
  let!(:submission) { create(:form_submission, :with_payload, form_action: action) }

  before(:each) do
    sign_in(user)
    visit "/forms/#{action.id}"
  end

  scenario "User reads a submission" do
    page.assert_selector("li.unread", count: 1)
    click_link("#{submission.created_at.strftime('%F')}")
    visit "/forms/#{action.id}"
    page.assert_selector("li.unread", count: 0)
    page.assert_selector("li.read", count: 1)
  end

  scenario "User views a submissions details" do
    click_link("#{submission.created_at.strftime('%F')}")
    page.has_text?('"key1"=>"value1"')
  end
end
