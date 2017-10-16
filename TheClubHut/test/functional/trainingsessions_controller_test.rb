require File.dirname(__FILE__) + '/../test_helper'

class TrainingsessionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:trainingsessions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_trainingsession
    assert_difference('Trainingsession.count') do
      post :create, :trainingsession => { }
    end

    assert_redirected_to trainingsession_path(assigns(:trainingsession))
  end

  def test_should_show_trainingsession
    get :show, :id => trainingsessions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => trainingsessions(:one).id
    assert_response :success
  end

  def test_should_update_trainingsession
    put :update, :id => trainingsessions(:one).id, :trainingsession => { }
    assert_redirected_to trainingsession_path(assigns(:trainingsession))
  end

  def test_should_destroy_trainingsession
    assert_difference('Trainingsession.count', -1) do
      delete :destroy, :id => trainingsessions(:one).id
    end

    assert_redirected_to trainingsessions_path
  end
end
