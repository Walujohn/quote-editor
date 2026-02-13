require 'rails_helper'

RSpec.describe "Quotes", type: :request do
  describe "GET /quotes" do
    it "redirects guests to sign in" do
      get quotes_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "responds successfully for signed-in users" do
      user = create(:user)
      sign_in user

      get quotes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /quotes" do
    it "creates a quote for signed-in users" do
      user = create(:user)
      sign_in user

      expect {
        post quotes_path, params: { quote: { name: "First Quote" } }
      }.to change(Quote, :count).by(1)

      expect(Quote.last.company_id).to eq(user.company_id)
    end

    it "responds with turbo stream when requested" do
      user = create(:user)
      sign_in user

      post quotes_path,
           params: { quote: { name: "Turbo Quote" } },
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET /quotes/:id" do
    it "responds successfully for signed-in users" do
      user = create(:user)
      quote = create(:quote, company: user.company)
      sign_in user

      get quote_path(quote)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "company isolation" do
    it "does not allow access to another company's quote" do
      company_a = create(:company)
      company_b = create(:company)

      user = create(:user, company: company_a)
      foreign_quote = create(:quote, company: company_b)

      sign_in user

      get quote_path(foreign_quote)

      # choose the behavior your app implements:
      # 404 is ideal, 302 redirect is also acceptable in some apps

      expect(response).to have_http_status(:not_found)
      # or, if you redirect instead:
      # expect(response).to have_http_status(:found)
    end
  end
end
