require "rails_helper"

RSpec.describe Quotes::TotalPrice do
  describe ".call" do
    it "sums quantity * unit_price across all line items on the quote" do
      quote = create(:quote)

      date = create(:line_item_date, quote: quote)

      create(:line_item, line_item_date: date, quantity: 2, unit_price: 10)
      create(:line_item, line_item_date: date, quantity: 3, unit_price: 20)

      expect(described_class.call(quote: quote)).to eq(80)
    end

    it "raises when quote is nil" do
      expect { described_class.call(quote: nil) }
        .to raise_error(ArgumentError, "quote is required")
    end
  end
end
