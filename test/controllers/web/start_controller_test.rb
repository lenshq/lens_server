require 'test_helper'

class Web::StartControllerTest < ActionController::TestCase
  test "start page working" do
    get :index
    assert response.status, 200
  end
end
