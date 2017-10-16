require File.dirname(__FILE__) + '/../test_helper'

class CommitteemembersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:committeemembers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_committeemember
    assert_difference('Committeemember.count') do
      post :create, :committeemember => { }
    end

    assert_redirected_to committeemember_path(assigns(:committeemember))
  end

  def test_should_show_committeemember
    get :show, :id => committeemembers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => committeemembers(:one).id
    assert_response :success
  end

  def test_should_update_committeemember
    put :update, :id => committeemembers(:one).id, :committeemember => { }
    assert_redirected_to committeemember_path(assigns(:committeemember))
  end

  def test_should_destroy_committeemember
    assert_difference('Committeemember.count', -1) do
      delete :destroy, :id => committeemembers(:one).id
    end

    assert_redirected_to committeemembers_path
  end
end
