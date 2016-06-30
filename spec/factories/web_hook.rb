FactoryGirl.define do
  factory :web_hook, class: WebHook do

    trait :valid do
      event_type 'submission'
      url 'http://www.example.com'
    end

    trait :on_form do
      webhookable { |w| w.association(:form_action) }
    end

  end
end
