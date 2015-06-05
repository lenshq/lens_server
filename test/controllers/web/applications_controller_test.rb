require 'test_helper'

class Web::ApplicationsControllerTest < ActionController::TestCase
  include AuthHelper

  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user
    @application = FactoryGirl.create(:application, user_id: @user.id)
    FactoryGirl.create(:application_user, user_id: @user.id, application_id: @application.id)

    load_fake_data_into_app(@application)
  end

  test "should get query" do
    get :query, {
      id: @application.id,
      date_from: Time.now - 1.week,
      date_to: Time.now,
      url: "/view/%",
      group_by: "day",
      duration_from: 100
    }
    assert_response :success

    puts "RESP: " + response.body
  end


end

