# spec/jobs/quotes/cleanup_empty_quotes_job_spec.rb
require "rails_helper"

RSpec.describe Quotes::CleanupEmptyQuotesJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  around do |ex|
    perform_enqueued_jobs { ex.run }
  end

  it "deletes old empty quotes for the company" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = create(:company)
      old_empty = create(:quote, company: company, created_at: 2.days.ago)
      keep_new  = create(:quote, company: company, created_at: 1.hour.ago)

      described_class.perform_later(company_id: company.id)

      expect(Quote.exists?(old_empty.id)).to be(false)
      expect(Quote.exists?(keep_new.id)).to be(true)
    end
  end

  it "does not delete quotes that have line items" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = create(:company)
      quote   = create(:quote, company: company, created_at: 2.days.ago)

      lid = create(:line_item_date, quote: quote)
      create(:line_item, line_item_date: lid)

      described_class.perform_later(company_id: company.id)

      expect(Quote.exists?(quote.id)).to be(true)
    end
  end

  it "does not delete quotes from other companies" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company1 = create(:company)
      company2 = create(:company)

      other_company_old_empty = create(:quote, company: company2, created_at: 2.days.ago)

      described_class.perform_later(company_id: company1.id)

      expect(Quote.exists?(other_company_old_empty.id)).to be(true)
    end
  end

  it "is idempotent (safe to run twice)" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = create(:company)
      old_empty = create(:quote, company: company, created_at: 2.days.ago)

      2.times { described_class.perform_later(company_id: company.id) }

      expect(Quote.exists?(old_empty.id)).to be(false)
    end
  end

  it "destroys dependent line_item_dates when deleting a quote" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = create(:company)
      quote   = create(:quote, company: company, created_at: 2.days.ago)

      lid = create(:line_item_date, quote: quote)
      # no line_items attached => should be candidate

      described_class.perform_later(company_id: company.id)

      expect(Quote.exists?(quote.id)).to be(false)
      expect(LineItemDate.exists?(lid.id)).to be(false)
    end
  end

  it "does not delete quotes exactly at the cutoff" do
    travel_to Time.zone.parse("2026-01-01 12:00:00") do
      company = create(:company)
      cutoff_quote = create(:quote, company: company, created_at: 1.day.ago)

      described_class.perform_later(company_id: company.id)

      expect(Quote.exists?(cutoff_quote.id)).to be(true)
    end
  end
end
