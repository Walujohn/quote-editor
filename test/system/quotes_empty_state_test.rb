require "application_system_test_case"

class QuotesEmptyStateTest < ApplicationSystemTestCase
  setup do
    @user = users(:accountant) # or however your fixture user is named
    login_as @user
  end

  test "shows empty state when there are no quotes" do
    Quote.where(company: @user.company).destroy_all

    visit quotes_path

    assert_text "You don't have any quotes yet!"
  end

  test "hides empty state when there are quotes" do
    Quote.where(company: @user.company).destroy_all
    Quote.create!(name: "Capybara quote", company: @user.company)

    visit quotes_path

    assert_no_text "You don't have any quotes yet!"
    assert_text "Capybara quote"
  end
end
