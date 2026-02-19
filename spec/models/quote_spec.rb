require 'rails_helper'

RSpec.describe Quote, type: :model do
  it "is valid with a name" do
    quote = build(:quote, name: "A quote")
    expect(quote).to be_valid
  end

  it "is invalid without a name" do
    # version of creating Quote that uses FactoryBot (for practice)
    quote = build(:quote, name: nil)
    expect(quote).not_to be_valid
  end

  it "has a unique name" do
    company = create(:company)

    create(:quote, name: "Unique rspec quote", company: company)
    quote = build(:quote, name: "Unique rspec quote", company: company)

    expect(quote).not_to be_valid
  end

  it "requires a company" do
    quote = build(:quote, company: nil)
    expect(quote).not_to be_valid
  end

  it "calculates the total price of the quote" do
    quote = create(:quote)
    date  = create(:line_item_date, quote: quote)

    create(:line_item, quantity: 2, unit_price: 10, line_item_date: date)
    create(:line_item, quantity: 3, unit_price: 20, line_item_date: date)

    expect(quote.total_price).to eq(80)
  end
end
