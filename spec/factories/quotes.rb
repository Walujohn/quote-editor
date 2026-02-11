FactoryBot.define do
  factory :quote do
    association :company
    sequence(:name) { |n| "Test quote #{n}" }
  end
end
