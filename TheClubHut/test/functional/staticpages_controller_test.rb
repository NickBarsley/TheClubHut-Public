require File.dirname(__FILE__) + '/../test_helper'

class StaticpagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:staticpages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_staticpage
    assert_difference('Staticpage.count') do
      post :create, :staticpage => { }
    end

    assert_redirected_to staticpage_path(assigns(:staticpage))
  end

  def test_should_show_staticpage
    get :show, :id => staticpages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => staticpages(:one).id
    assert_response :success
  end

  def test_should_update_staticpage
    put :update, :id => staticpages(:one).id, :staticpage => { }
    assert_redirected_to staticpage_path(assigns(:staticpage))
  end

  def test_should_destroy_staticpage
    assert_difference('Staticpage.count', -1) do
      delete :destroy, :id => staticpages(:one).id
    end

    assert_redirected_to staticpages_path
  end
end
