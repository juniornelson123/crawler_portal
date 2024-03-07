require "application_system_test_case"

class DissertationsTest < ApplicationSystemTestCase
  setup do
    @dissertation = dissertations(:one)
  end

  test "visiting the index" do
    visit dissertations_url
    assert_selector "h1", text: "Dissertations"
  end

  test "should create dissertation" do
    visit dissertations_url
    click_on "New dissertation"

    fill_in "Date", with: @dissertation.date
    fill_in "Evaluations", with: @dissertation.evaluations
    fill_in "Kind", with: @dissertation.kind
    fill_in "Link", with: @dissertation.link
    fill_in "Name", with: @dissertation.name
    fill_in "Title", with: @dissertation.title
    fill_in "Year", with: @dissertation.year
    click_on "Create Dissertation"

    assert_text "Dissertation was successfully created"
    click_on "Back"
  end

  test "should update Dissertation" do
    visit dissertation_url(@dissertation)
    click_on "Edit this dissertation", match: :first

    fill_in "Date", with: @dissertation.date
    fill_in "Evaluations", with: @dissertation.evaluations
    fill_in "Kind", with: @dissertation.kind
    fill_in "Link", with: @dissertation.link
    fill_in "Name", with: @dissertation.name
    fill_in "Title", with: @dissertation.title
    fill_in "Year", with: @dissertation.year
    click_on "Update Dissertation"

    assert_text "Dissertation was successfully updated"
    click_on "Back"
  end

  test "should destroy Dissertation" do
    visit dissertation_url(@dissertation)
    click_on "Destroy this dissertation", match: :first

    assert_text "Dissertation was successfully destroyed"
  end
end
