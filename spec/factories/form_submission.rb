FactoryGirl.define do

  factory(:form_submission, class: FormSubmission) do

      trait :with_payload do
        payload { { key1: "value1",
                    key2: "value2"} }
      end

      trait :with_attachment do
        attachment "This is a file.\n"
        attachment_name "example_file.txt"
        attachment_type "text/plain"
      end

    association :form_action, factory: :form_action, strategy: :build
  end
end
