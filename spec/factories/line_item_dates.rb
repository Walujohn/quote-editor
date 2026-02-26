FactoryBot.define do
  factory :line_item_date do
    association :quote
    sequence(:date) { |n| Date.current + n.days }
  end
end
