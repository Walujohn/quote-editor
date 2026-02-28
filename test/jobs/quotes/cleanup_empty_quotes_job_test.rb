# test/jobs/quotes/cleanup_empty_quotes_job_test.rb
require "test_helper"

class Quotes::CleanupEmptyQuotesJobTest < ActiveJob::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "deletes old empty quotes for the company" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = companies(:kpmg)

      old_empty = Quote.create!(
        company: company,
        name: "Old Empty",
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )

      keep_new = Quote.create!(
        company: company,
        name: "New Empty",
        created_at: 1.hour.ago,
        updated_at: 1.hour.ago
      )

      assert_enqueued_with(job: Quotes::CleanupEmptyQuotesJob, args: [ { company_id: company.id } ]) do
        Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company.id)
      end

      perform_enqueued_jobs

      assert_not Quote.exists?(old_empty.id)
      assert Quote.exists?(keep_new.id)
    end
  end

  test "does not delete quotes with line items" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = companies(:kpmg)

      quote = Quote.create!(
        company: company,
        name: "Has items",
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )

      lid = LineItemDate.create!(
        quote: quote,
        date: Date.current
      )

      LineItem.create!(
        line_item_date: lid,
        name: "Item",
        quantity: 1,
        unit_price: 1000
      )

      Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company.id)
      perform_enqueued_jobs

      assert Quote.exists?(quote.id), "Expected quote with line items to remain"
    end
  end

  test "does not delete quotes from other companies" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company1 = companies(:kpmg)
      company2 = companies(:pwc)

      other_company_old_empty = Quote.create!(
        company: company2,
        name: "Other company's old empty",
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )

      Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company1.id)
      perform_enqueued_jobs

      assert Quote.exists?(other_company_old_empty.id), "Expected other company's quote to remain"
    end
  end

  test "is idempotent (safe to run twice)" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = companies(:kpmg)

      old_empty = Quote.create!(
        company: company,
        name: "Old Empty",
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )

      2.times { Quotes::CleanupEmptyQuotesJob.perform_later(company_id: company.id) }
      perform_enqueued_jobs

      assert_not Quote.exists?(old_empty.id)
    end
  end
end
