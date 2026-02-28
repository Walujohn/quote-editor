# app/jobs/quotes/enqueue_cleanup_empty_quotes_job.rb
class Quotes::EnqueueCleanupEmptyQuotesJob < ApplicationJob
  queue_as :maintenance

  def perform
    Company.find_each do |company|
      Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company.id)
    end
  end
end
