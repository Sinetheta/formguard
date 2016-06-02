FactoryGirl.define do

  factory(:form_submission, class: FormSubmission) do

      trait :with_payload do
        payload { { key1: "value1",
                    key2: "value2"} }
      end

    association :form_action, factory: :form_action, strategy: :build
  end
end
