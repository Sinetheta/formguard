FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory(:user, class: User) do
    email { generate(:email) }
    password "password"
    password_confirmation "password"
  end
end
