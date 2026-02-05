FactoryBot.define do
  factory :quote do
    sequence(:name) { |n| "Test quote #{n}" }
  end
end
