require "test_helper"

class WordsearchControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get wordsearch_show_url
    assert_response :success
  end
end
