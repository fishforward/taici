require 'test_helper'

class TaiciaControllerTest < ActionController::TestCase
  setup do
    @taicium = taicia(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taicia)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taicium" do
    assert_difference('Taicium.count') do
      post :create, taicium: { content: @taicium.content, creator_id: @taicium.creator_id, creator_name: @taicium.creator_name, no: @taicium.no, source: @taicium.source, tag: @taicium.tag, type: @taicium.type, yes: @taicium.yes }
    end

    assert_redirected_to taicium_path(assigns(:taicium))
  end

  test "should show taicium" do
    get :show, id: @taicium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taicium
    assert_response :success
  end

  test "should update taicium" do
    put :update, id: @taicium, taicium: { content: @taicium.content, creator_id: @taicium.creator_id, creator_name: @taicium.creator_name, no: @taicium.no, source: @taicium.source, tag: @taicium.tag, type: @taicium.type, yes: @taicium.yes }
    assert_redirected_to taicium_path(assigns(:taicium))
  end

  test "should destroy taicium" do
    assert_difference('Taicium.count', -1) do
      delete :destroy, id: @taicium
    end

    assert_redirected_to taicia_path
  end
end
