require 'rails_helper'

RSpec.describe Quote, type: :model do
  it "is valid with a name" do
    quote = Quote.new(name: "A quote")
    expect(quote).to be_valid
  end

  it "is invalid without a name" do
    # version of creating Quote that uses FactoryBot (for practice)
    quote = build(:quote, name: nil)
    expect(quote).not_to be_valid
  end
end
