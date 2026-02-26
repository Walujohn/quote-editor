# app/services/quotes/total_price.rb
module Quotes
  class TotalPrice
    def self.call(quote:)
      new(quote:).call
    end

    def initialize(quote:)
      @quote = quote
    end

    def call
      raise ArgumentError, "quote is required" unless quote

      # Keep logic explicit and readable
      line_items.sum { |li| li.quantity * li.unit_price }
    end

    private

    attr_reader :quote

    def line_items
      quote.line_items
    end
  end
end
