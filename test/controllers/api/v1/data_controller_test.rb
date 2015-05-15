require 'test_helper'

class Api::V1::DataControllerTest < ActionController::TestCase
  test "should post rec" do
    get :rec
    assert_response :success
  end
end

