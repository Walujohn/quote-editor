require "test_helper"

class Quotes::CleanupEmptyQuotesJobTest < ActiveJob::TestCase
  test "deletes old empty quotes for the company" do
    company = companies(:kpmg)

    old_empty = Quote.create!(company: company, name: "Old Empty", created_at: 2.days.ago, updated_at: 2.days.ago)
    keep_new  = Quote.create!(company: company, name: "New Empty", created_at: 1.hour.ago, updated_at: 1.hour.ago)

    assert_enqueued_with(job: Quotes::CleanupEmptyQuotesJob, args: [ { company_id: company.id } ]) do
      Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company.id)
    end

    perform_enqueued_jobs

    assert_not Quote.exists?(old_empty.id)
    assert Quote.exists?(keep_new.id)
  end
end
