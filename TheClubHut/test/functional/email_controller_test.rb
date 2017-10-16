require File.dirname(__FILE__) + '/../test_helper'
require 'email_controller'

# Re-raise errors caught by the controller.
class EmailController; def rescue_action(e) raise e end; end

class EmailControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = EmailController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @emails     = ActionMailer::Base.deliveries
    @emails.clear
    @user = users(:valid_user)
    # Make sure deliveries aren't actually made!
    ActionMailer::Base.delivery_method = :test
  end

  def test_password_reminder
    post :remind, :user => { :email => @user.email }
    assert_response :redirect
    assert_redirected_to :action => "index", :controller => "site"
    assert_equal "Login information was sent.", flash[:notice]
    assert_equal 1, @emails.length
  end
end
