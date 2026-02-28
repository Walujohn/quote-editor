require "application_system_test_case"

class ReactQuotesTest < ApplicationSystemTestCase
  setup do
    login_as users(:accountant)
  end

  test "shows an empty state when there are no quotes" do
    visit react_quotes_path

    assert_text "No quotes found."
  end

  test "shows quotes from the API" do
    company = users(:accountant).company
    quote_one = Quote.create!(company: company, name: "React Quote One")
    quote_two = Quote.create!(company: company, name: "React Quote Two")
    other_quote = Quote.create!(company: companies(:pwc), name: "Not My Quote")

    visit react_quotes_path

    assert_text quote_one.name
    assert_text quote_two.name
    assert_no_text other_quote.name
  end
end
