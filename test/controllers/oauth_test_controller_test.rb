require 'test_helper'

class OauthTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get oauth_test_index_url
    assert_response :success
  end

end
