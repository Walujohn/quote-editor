require "application_system_test_case"

class QuotesTest < ApplicationSystemTestCase
  setup do
    @quote = Quote.ordered.first
  end

  test "Showing a quote" do
    visit quotes_path
    click_link @quote.name

    assert_selector "h1", text: @quote.name
  end

  test "Creating a new quote" do
    visit quotes_path
    assert_selector "h1", text: "Quotes"

    click_on "New quote"
    assert_selector "form"
    fill_in "Name", with: "Capybara quote"

    assert_selector "h1", text: "Quotes"
    click_on "Create quote"

    assert_selector "h1", text: "Quotes"
    assert_text "Capybara quote"
  end

  test "Updating a quote" do
    visit quotes_path
    assert_selector "h1", text: "Quotes"

    click_on "Edit", match: :first
    assert_selector "form"
    fill_in "Name", with: "Updated quote"

    assert_selector "h1", text: "Quotes"
    click_on "Update quote"

    assert_selector "h1", text: "Quotes"
    assert_text "Updated quote"
  end

  test "Destroying a quote" do
    visit quotes_path
    assert_text @quote.name

    click_on "Delete", match: :first
    assert_no_text @quote.name
  end
  test "Cancel clears the new quote form" do
    visit quotes_path
    click_on "New quote"

    within "turbo-frame#new_quote" do
      fill_in "quote[name]", with: "Capybara quote"
      click_on "Cancel"
    end

    within "turbo-frame#new_quote" do
      assert_no_selector "form"
      assert_no_selector "input[name='quote[name]']"
    end

    # Still on the index page with the list of quotes because of Turbo
    assert_selector "h1", text: "Quotes"
  end

  test "Canceling an edit restores the original quote row" do
    visit quotes_path
    quote = quotes(:first)
    original_name = quote.name

    # Open edit for this specific row
    within "##{dom_id(quote)}" do
      click_on "Edit"
      assert_selector "form"
    end

    # In the edit frame, type a change but cancel it
    within "##{dom_id(quote, :edit)}" do
      fill_in "quote[name]", with: "Should not persist capybara quote name"
      click_on "Cancel"
    end

    # After cancel, the row should show the original name again
    within "##{dom_id(quote)}" do
      assert_text original_name
    end

    # And the canceled text should not appear anywhere
    assert_no_text "Should not persist capybara quote name"
  end
end
