require 'test_helper'

class TaiciisControllerTest < ActionController::TestCase
  setup do
    @taicii = taiciis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taiciis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taicii" do
    assert_difference('Taicii.count') do
      post :create, taicii: { content: @taicii.content, creator_id: @taicii.creator_id, creator_name: @taicii.creator_name, no: @taicii.no, source: @taicii.source, tag: @taicii.tag, type: @taicii.type, yes: @taicii.yes }
    end

    assert_redirected_to taicii_path(assigns(:taicii))
  end

  test "should show taicii" do
    get :show, id: @taicii
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taicii
    assert_response :success
  end

  test "should update taicii" do
    put :update, id: @taicii, taicii: { content: @taicii.content, creator_id: @taicii.creator_id, creator_name: @taicii.creator_name, no: @taicii.no, source: @taicii.source, tag: @taicii.tag, type: @taicii.type, yes: @taicii.yes }
    assert_redirected_to taicii_path(assigns(:taicii))
  end

  test "should destroy taicii" do
    assert_difference('Taicii.count', -1) do
      delete :destroy, id: @taicii
    end

    assert_redirected_to taiciis_path
  end
end
