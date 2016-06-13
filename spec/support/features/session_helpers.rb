module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button "Sign up"
    end

    def sign_in(user)
      visit new_user_registration_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      click_button "Sign up"
    end
  end
end
