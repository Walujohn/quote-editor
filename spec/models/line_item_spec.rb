require 'rails_helper'

RSpec.describe LineItem, type: :model do
  it "returns the total price of the line item" do
    line_item = LineItem.new(quantity: 5, unit_price: 10)
    expect(line_item.total_price).to eq(50)
  end
end
