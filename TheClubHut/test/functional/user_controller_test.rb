require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  include ApplicationHelper
  fixtures :users
  
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # This user is initially valid, but we may change its attributes.
    @valid_user = users(:valid_user)
  end

  # Make sure the registration page responds with the proper form.
  def test_registration_page
    get :register
    title = assigns(:title)
    assert_equal "sipbib: register", title
    assert_response :success
    assert_template "register"
    # Test the form and all its tags.
    assert_form_tag "/user/register"
    assert_email_field
		assert_password_field
    assert_password_field "password_confirmation"
    assert_submit_button "Register!"                                              
  end
  
  # Test a valid registration. 
  def test_registration_success 
    post :register, :user => { :firstname => "Nick",
                               :surname => "Barsley",
                               :email       => "valid@example.com", 
                               :password     => "long_enough_password" } 
    # Test assignment of user. 
    user = assigns(:user) 
    assert_not_nil user 
    # Test new user in database. 
    new_user = User.find_by_email_and_password(user.email, 
                                                     user.password) 
    assert_equal new_user, user 
    # Test flash and redirect. 
    assert_equal "User #{new_user.firstname} created!", flash[:notice] 
    assert_redirected_to :action => "index" 
    
    # Make sure user is logged in properly.
    assert logged_in?
    assert_equal user.id, session[:user_id]
  end 
  
 
  # Make sure the login page works and has the right fields.
  def test_login_page
    get :login
    title = assigns(:title)
    assert_equal "sipbib: login", title
    assert_response :success
    assert_template "login"
    assert_tag "form", :attributes => { :action => "/user/login", 
                                        :method => "post" }
    assert_tag "input", :attributes => { :name => "user[remember_me]",
                                         :type => "checkbox" }
    assert_tag "input", :attributes => { :type => "submit",
                                         :value => "Login!" }     
  end
  
  # Test a login with invalid email.
  def test_login_failure_with_nonexistent_email
    invalid_user = @valid_user
    invalid_user.email = "no such user"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid email/password combination", flash[:notice]
    # Make sure screen_name will be redisplayed, but not the password.
    user = assigns(:user)
    assert_equal invalid_user.email, user.email
    assert_nil user.password
  end

  # Test a login with invalid password.
  def test_login_failure_with_wrong_password
    invalid_user = @valid_user
    # Construct an invalid password.
    invalid_user.password += "baz"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid email/password combination", flash[:notice]
    # Make sure screen_name will be redisplayed, but not the password.
    user = assigns(:user)
    assert_equal invalid_user.email, user.email
    assert_nil user.password
  end

# Test the navigation menu after login.
  def test_navigation_logged_in
    authorize @valid_user
    get :index
    assert_tag "a", :content => /Log Out/,
               :attributes => { :href => "/user/logout" } 
    assert_no_tag "a", :content => /Register/    
    assert_no_tag "a", :content => /Login/
  end
  
  # Test index page for unauthorized user.
  def test_index_unauthorized
    # Make sure the before_filter is working.
    get :index
    assert_response :redirect
    assert_redirected_to :action => "login"
    assert_equal "Please log in first", flash[:notice]
  end
  
  # Test index page for authorized user.
  def test_index_authorized
    authorize @valid_user
    get :index
    assert_response :success
    assert_template "index"
  end
  
 
 
  # Test the edit page.
  def test_edit_page
    authorize @valid_user
    get :edit
    title = assigns(:title)
    assert_equal "Edit basic info", title
    assert_response :success
    assert_template "edit"
    # Test the form and all its tags.
    assert_form_tag "/user/edit"
    assert_email_field @valid_user.email
    assert_password_field "current_password"
    assert_password_field
    assert_password_field "password_confirmation"
    assert_submit_button "Update"
  end
  
  private
  
  # Try to log a user in using the login action.
  # Pass :remember_me => "0" or :remember_me => "1" in options
  # to invoke the remember me machinery.
  def try_to_login(user, options = {})
    user_hash = { :email => user.email,
                  :password    => user.password }
    user_hash.merge!(options)
    post :login, :user => user_hash 
  end
  
  # Authorize a user.
  def authorize(user)
    @request.session[:user_id] = user.id
  end
  
  
  # Assert that the email field has the correct HTML.
  def assert_email_field(email = nil, options = {})
    assert_input_field("user[email]", email, "text",
                       User::EMAIL_SIZE, User::EMAIL_MAX_LENGTH,
                       options)
  end
  
  # Assert that the password field has the correct HTML.
  def assert_password_field(password_field_name = "password", options = {})
    # We never want a password to appear pre-filled into a form.
    blank = nil
    assert_input_field("user[#{password_field_name}]", blank, "password",
                       User::PASSWORD_SIZE, User::PASSWORD_MAX_LENGTH,
                       options)
  end
    
  
  # Return the cookie value given a symbol.
  def cookie_value(symbol)
    cookies[symbol.to_s].value.first
  end
  
  #Return the cookie expiration given a symbol.
  def cookie_expires(symbol)
    cookies[symbol.to_s].expires
  end
end
