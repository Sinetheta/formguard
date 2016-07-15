FactoryGirl.define do
  factory :filtered_form_submission, class: FilteredFormSubmission do

    trait :start_date do
      start_date "2000-1-1"
    end

    trait :end_date do
      end_date "2001-1-1"
    end

    association :form_action, factory: :form_action, strategy: :build
  end
end
