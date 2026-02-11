FactoryBot.define do
  factory :user do
    association :company
    email { "user@example.com" }
    password { "password123" }
  end
end
