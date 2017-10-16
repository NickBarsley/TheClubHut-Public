require File.dirname(__FILE__) + '/../test_helper'

class CommitteesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:committees)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_committee
    assert_difference('Committee.count') do
      post :create, :committee => { }
    end

    assert_redirected_to committee_path(assigns(:committee))
  end

  def test_should_show_committee
    get :show, :id => committees(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => committees(:one).id
    assert_response :success
  end

  def test_should_update_committee
    put :update, :id => committees(:one).id, :committee => { }
    assert_redirected_to committee_path(assigns(:committee))
  end

  def test_should_destroy_committee
    assert_difference('Committee.count', -1) do
      delete :destroy, :id => committees(:one).id
    end

    assert_redirected_to committees_path
  end
end
