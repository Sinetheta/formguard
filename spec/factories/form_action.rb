FactoryGirl.define do
  factory(:form_action, class: FormAction) do
    name "example form"
    association :user, factory: :user, strategy: :build
  end
end
