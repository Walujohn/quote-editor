require "rails_helper"

RSpec.describe Quotes::CleanupEmptyQuotesJob, type: :job do
  include ActiveJob::TestHelper

  it "deletes old empty quotes for the company" do
    company = create(:company)

    old_empty = create(:quote, company: company, created_at: 2.days.ago, updated_at: 2.days.ago)
    keep_new  = create(:quote, company: company, created_at: 1.hour.ago, updated_at: 1.hour.ago)

    expect {
      described_class.perform_later(company_id: company.id)
    }.to have_enqueued_job(described_class)

    perform_enqueued_jobs

    expect(Quote.exists?(old_empty.id)).to be(false)
    expect(Quote.exists?(keep_new.id)).to be(true)
  end
end
