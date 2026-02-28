# app/jobs/quotes/cleanup_empty_quotes_job.rb
class Quotes::CleanupEmptyQuotesJob < ApplicationJob
  queue_as :maintenance # (or :default if that’s what your org uses)

  def perform(company_id:)
    cutoff = 1.day.ago

    candidates = Quote
      .where(company_id: company_id)
      .where("quotes.created_at < ?", cutoff)
      # NOT EXISTS expresses "no associated line items" directly and avoids
      # GROUP/HAVING aggregation overhead on large datasets.
      .where(<<~SQL)
        NOT EXISTS (
          SELECT 1
          FROM line_item_dates
          INNER JOIN line_items ON line_items.line_item_date_id = line_item_dates.id
          WHERE line_item_dates.quote_id = quotes.id
        )
      SQL

    candidate_count = candidates.count
    Rails.logger.info("[CleanupEmptyQuotesJob] company_id=#{company_id} cutoff=#{cutoff.iso8601} candidates=#{candidate_count}")

    deleted = 0
    candidates.in_batches(of: 500) do |batch|
      deleted += batch.destroy_all.size
    end

    Rails.logger.info("[CleanupEmptyQuotesJob] company_id=#{company_id} deleted=#{deleted}")
  end
end
