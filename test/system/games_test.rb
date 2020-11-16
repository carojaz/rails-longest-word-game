require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit new_url

    assert_selector "h1", text: "Game"
  end

  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Filling the form with a random word, click the play button, and get a message that the word is not in the grid" do
    visit new_url
    fill_in "word", with: "bonjour"
    click_on "Play"

    assert_selector "p", text: "Nice try but"
  end
end
