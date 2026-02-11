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
end
