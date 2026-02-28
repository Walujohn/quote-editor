require "rails_helper"

RSpec.describe "Api::V1::Quotes", type: :request do
  describe "GET /api/v1/quotes" do
    it "returns latest quotes for a company" do
      company = create(:company)
      other_company = create(:company)

      older_quote = create(:quote, company: company, name: "Older Quote", updated_at: 2.days.ago)
      newer_quote = create(:quote, company: company, name: "Newer Quote", updated_at: 1.day.ago)
      create(:quote, company: other_company, name: "Other Company Quote")

      get "/api/v1/quotes", params: { company_id: company.id }

      expect(response).to have_http_status(:ok)

      payload = JSON.parse(response.body)
      expect(payload).to include("data")
      expect(payload["data"]).to be_an(Array)

      returned_ids = payload["data"].map { |quote| quote["id"] }
      expect(returned_ids).to eq([ newer_quote.id, older_quote.id ])

      first_quote = payload["data"].first
      expect(first_quote.keys).to contain_exactly("id", "company_id", "name", "created_at", "updated_at")
    end

    it "returns 4xx when company_id is missing" do
      get "/api/v1/quotes"

      expect(response.status).to be_between(400, 499)
    end
  end
end
