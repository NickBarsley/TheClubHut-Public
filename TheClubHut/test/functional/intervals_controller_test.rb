require File.dirname(__FILE__) + '/../test_helper'

class IntervalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:intervals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_interval
    assert_difference('Interval.count') do
      post :create, :interval => { }
    end

    assert_redirected_to interval_path(assigns(:interval))
  end

  def test_should_show_interval
    get :show, :id => intervals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => intervals(:one).id
    assert_response :success
  end

  def test_should_update_interval
    put :update, :id => intervals(:one).id, :interval => { }
    assert_redirected_to interval_path(assigns(:interval))
  end

  def test_should_destroy_interval
    assert_difference('Interval.count', -1) do
      delete :destroy, :id => intervals(:one).id
    end

    assert_redirected_to intervals_path
  end
end
