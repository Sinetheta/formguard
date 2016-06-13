FactoryGirl.define do
  factory(:form_action, class: FormAction) do

    trait :notification_enabled do
      should_notify true
    end

    trait :with_mailing_list do
      emails ["user_one@example.com", "user_two@example.com"]
    end

    name "example form"
    association :user, factory: :user, strategy: :build
  end
end
