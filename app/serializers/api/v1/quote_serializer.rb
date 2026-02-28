class Api::V1::QuoteSerializer
  def self.render_collection(quotes)
    {
      data: quotes.map { |quote| serialize(quote) }
    }
  end

  def self.serialize(quote)
    {
      id: quote.id,
      company_id: quote.company_id,
      name: quote.name,
      created_at: quote.created_at.iso8601,
      updated_at: quote.updated_at.iso8601
    }
  end
end
