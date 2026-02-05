require 'rails_helper'

RSpec.describe "Quotes", type: :request do
  describe "GET /quotes" do
    it "responds successfully" do
      get quotes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /quotes" do
    it "creates a quote" do
      expect {
        post quotes_path, params: { quote: { name: "First Quote" } }
      }.to change(Quote, :count).by(1)
    end
  end

  describe "GET /quotes/:id" do
    it "responds successfully" do
      quote = create(:quote)

      get quote_path(quote)
      expect(response).to have_http_status(:ok)
    end
  end
end
