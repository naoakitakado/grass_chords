require "application_system_test_case"

class SongsTest < ApplicationSystemTestCase
  setup do
    @song = songs(:one)
  end

  test "visiting the index" do
    visit songs_url
    assert_selector "h1", text: "Songs"
  end

  test "creating a Song" do
    visit songs_url
    click_on "New Song"

    check "Beginner" if @song.beginner
    check "Jam" if @song.jam
    fill_in "Standard", with: @song.standard
    fill_in "Title", with: @song.title
    fill_in "User", with: @song.user_id
    click_on "Create Song"

    assert_text "Song was successfully created"
    click_on "Back"
  end

  test "updating a Song" do
    visit songs_url
    click_on "Edit", match: :first

    check "Beginner" if @song.beginner
    check "Jam" if @song.jam
    fill_in "Standard", with: @song.standard
    fill_in "Title", with: @song.title
    fill_in "User", with: @song.user_id
    click_on "Update Song"

    assert_text "Song was successfully updated"
    click_on "Back"
  end

  test "destroying a Song" do
    visit songs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Song was successfully destroyed"
  end
end
