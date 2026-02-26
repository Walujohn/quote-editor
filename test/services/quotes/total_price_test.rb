require "test_helper"

class Quotes::TotalPriceTest < ActiveSupport::TestCase
  test "sums quantity * unit_price across all line items on the quote" do
    company = Company.create!(name: "TestCo")
    quote   = Quote.create!(name: "Quote", company:)

    today   = LineItemDate.create!(quote:, date: Date.current)
    week    = LineItemDate.create!(quote:, date: Date.current + 1.week)

    LineItem.create!(line_item_date: today, name: "A", quantity: 2, unit_price: 10) # 20
    LineItem.create!(line_item_date: today, name: "B", quantity: 3, unit_price: 20) # 60
    LineItem.create!(line_item_date: week,  name: "C", quantity: 1, unit_price: 5)  # 5

    assert_equal 85, Quotes::TotalPrice.call(quote:)
  end

  test "raises when quote is nil" do
    assert_raises(ArgumentError) do
      Quotes::TotalPrice.call(quote: nil)
    end
  end
end
