require File.dirname(__FILE__) + '/../test_helper'

class JamiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:jamies)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_jamie
    assert_difference('Jamie.count') do
      post :create, :jamie => { }
    end

    assert_redirected_to jamie_path(assigns(:jamie))
  end

  def test_should_show_jamie
    get :show, :id => jamies(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => jamies(:one).id
    assert_response :success
  end

  def test_should_update_jamie
    put :update, :id => jamies(:one).id, :jamie => { }
    assert_redirected_to jamie_path(assigns(:jamie))
  end

  def test_should_destroy_jamie
    assert_difference('Jamie.count', -1) do
      delete :destroy, :id => jamies(:one).id
    end

    assert_redirected_to jamies_path
  end
end
