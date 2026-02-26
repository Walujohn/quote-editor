require "test_helper"

class Quotes::VisibleToTest < ActiveSupport::TestCase
  test "returns only quotes for the user's company" do
    company_a = Company.create!(name: "A")
    company_b = Company.create!(name: "B")

    user = User.create!(
      company: company_a,
      email: "a@example.com",
      password: "password"
    )

    visible = Quote.create!(company: company_a, name: "Visible")
    hidden  = Quote.create!(company: company_b, name: "Hidden")

    results = Quotes::VisibleTo.new(user: user).call

    assert_includes results, visible
    assert_not_includes results, hidden
  end
end
