FactoryBot.define do
  factory :quote do
    association :company
    sequence(:name) { |n| "Quote #{n}" }
  end
end
