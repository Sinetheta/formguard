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
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end

    def sign_out
      click_link "Logout"
    end

    def while_signed_in_as(user)
      sign_in(user)
      yield
      sign_out
    end
  end
end
