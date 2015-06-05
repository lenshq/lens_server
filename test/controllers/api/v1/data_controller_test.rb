require 'test_helper'

class Api::V1::DataControllerTest < ActionController::TestCase
  def setup
    @app = FactoryGirl.create(:application)
  end

  def login
    @request.headers["X-Auth-Token"] = @app.token
  end

  test "должно записывать если входные параметры правильные" do
    login
    post :rec, generate_fake_event_data.merge(api_token: @app.token)
    assert_response :success
  end

  test "должно записывать входные данные правильно при втором и следующих запросах" do
    100.times do
      post :rec, generate_fake_event_data.merge(api_token: @app.token)
      assert_response :success
    end
  end

  test "должно выдавать ошибку если кривые данные" do
    post :rec, {"zhopa" => 123, api_token: @app.token}
    assert_response 422
  end

  test "должно выдавать 403 если нет токена" do
    post :rec, generate_fake_event_data
    assert_response 403
  end

end

