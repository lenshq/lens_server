require 'test_helper'

class Web::ApplicationsControllerTest < ActionController::TestCase
  def setup
    @application = FactoryGirl.create(:application)

    load_fake_data_into_app(@application)
  end

  test "should get query" do
    get :query, {id: @application.id, date_from: Time.now - 1.week, date_to: Time.now, url: "/view/*", group_by: "day", duration_from: 1000}
    assert_response :success
  end


end

