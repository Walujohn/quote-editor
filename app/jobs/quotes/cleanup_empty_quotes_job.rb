# app/jobs/quotes/cleanup_empty_quotes_job.rb
class Quotes::CleanupEmptyQuotesJob < ApplicationJob
  queue_as :default

  # Call with: perform_later(company_id: ...)
  def perform(company_id:)
    Quote
      .where(company_id: company_id)
      .where("quotes.created_at < ?", 1.day.ago)
      .left_joins(line_item_dates: :line_items)
      .group("quotes.id")
      .having("COUNT(line_items.id) = 0")
      .find_each(&:destroy)
  end
end
