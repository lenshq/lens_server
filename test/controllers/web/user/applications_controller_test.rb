require 'test_helper'

class Web::User::ApplicationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should post query" do
    get :query, {date_from: Time.now - 1.week, date_to: Time.now, url: "/view/*", group_by: "day", duration_from: 1000}
    assert_response :success
  end

end
