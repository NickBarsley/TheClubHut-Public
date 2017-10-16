require File.dirname(__FILE__) + '/../test_helper'

class WhatshappeningsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:whatshappenings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_whatshappening
    assert_difference('Whatshappening.count') do
      post :create, :whatshappening => { }
    end

    assert_redirected_to whatshappening_path(assigns(:whatshappening))
  end

  def test_should_show_whatshappening
    get :show, :id => whatshappenings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => whatshappenings(:one).id
    assert_response :success
  end

  def test_should_update_whatshappening
    put :update, :id => whatshappenings(:one).id, :whatshappening => { }
    assert_redirected_to whatshappening_path(assigns(:whatshappening))
  end

  def test_should_destroy_whatshappening
    assert_difference('Whatshappening.count', -1) do
      delete :destroy, :id => whatshappenings(:one).id
    end

    assert_redirected_to whatshappenings_path
  end
end
