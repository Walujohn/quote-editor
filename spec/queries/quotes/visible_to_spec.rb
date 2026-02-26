require "rails_helper"

RSpec.describe Quotes::VisibleTo do
  describe "#call" do
    it "returns only quotes for the user's company" do
      company_a = create(:company)
      company_b = create(:company)

      user = create(:user, company: company_a)

      visible = create(:quote, company: company_a, name: "Visible")
      hidden  = create(:quote, company: company_b, name: "Hidden")

      results = described_class.new(user: user).call

      expect(results).to include(visible)
      expect(results).not_to include(hidden)
    end

    it "returns quotes ordered (newest first) using Quote.ordered" do
      company = create(:company)
      user = create(:user, company: company)

      older = create(:quote, company: company, name: "Older")
      newer = create(:quote, company: company, name: "Newer")

      results = described_class.new(user: user).call.to_a
      expect(results.first).to eq(newer)
      expect(results.last).to eq(older)
    end
  end
end
