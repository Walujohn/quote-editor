class Api::V1::QuotesController < Api::V1::BaseController
  def index
    company_id = params.require(:company_id)
    quotes = Quote.where(company_id: company_id).order(updated_at: :desc).limit(50)

    render json: Api::V1::QuoteSerializer.render_collection(quotes)
  rescue ActionController::ParameterMissing
    render json: { error: "company_id is required" }, status: :bad_request
  end
end
