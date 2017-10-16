require File.dirname(__FILE__) + '/../test_helper'

class SubstitutesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:substitutes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_substitute
    assert_difference('Substitute.count') do
      post :create, :substitute => { }
    end

    assert_redirected_to substitute_path(assigns(:substitute))
  end

  def test_should_show_substitute
    get :show, :id => substitutes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => substitutes(:one).id
    assert_response :success
  end

  def test_should_update_substitute
    put :update, :id => substitutes(:one).id, :substitute => { }
    assert_redirected_to substitute_path(assigns(:substitute))
  end

  def test_should_destroy_substitute
    assert_difference('Substitute.count', -1) do
      delete :destroy, :id => substitutes(:one).id
    end

    assert_redirected_to substitutes_path
  end
end
