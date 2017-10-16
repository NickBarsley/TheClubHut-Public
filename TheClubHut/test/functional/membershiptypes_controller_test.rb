require File.dirname(__FILE__) + '/../test_helper'

class MembershiptypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:membershiptypes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_membershiptype
    assert_difference('Membershiptype.count') do
      post :create, :membershiptype => { }
    end

    assert_redirected_to membershiptype_path(assigns(:membershiptype))
  end

  def test_should_show_membershiptype
    get :show, :id => membershiptypes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => membershiptypes(:one).id
    assert_response :success
  end

  def test_should_update_membershiptype
    put :update, :id => membershiptypes(:one).id, :membershiptype => { }
    assert_redirected_to membershiptype_path(assigns(:membershiptype))
  end

  def test_should_destroy_membershiptype
    assert_difference('Membershiptype.count', -1) do
      delete :destroy, :id => membershiptypes(:one).id
    end

    assert_redirected_to membershiptypes_path
  end
end
