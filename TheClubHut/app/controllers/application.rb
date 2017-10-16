# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ApplicationHelper
    
  if ENV["RAILS_ENV"] == "development"
    #require "vendor/plugins/redcloth/lib/redcloth.rb"
  elsif ENV["RAILS_ENV"] == "production"
    require 'redcloth'
  end
  
  
  helper :profile, :avatar, :clubavatar, :user
  

  before_filter :check_authorization
  require 'date' 
  require 'observer'
  
  # Log a user in by authorization cookie if necessary.
  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.login!(session) if user
    end
  end

    def authorized?() 
			true 
			# in your code, redirect to an appropriate page if not an admin
		end

    def current_user
      if session[:user_id]
        @current_user = User.find_by_id(session[:user_id])
      end
      
    end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(sym)
    request.post? and params[sym]
  end
    
  # Protect a page from unauthorized access.
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :controller => "user", :action => "login"
      return false
    end
  end
  
  def login_required
    if session[:user_id] != nil
      return true
    else
      return false
    end
  end
  
  
  # Protect a club page from a non-club member
  def club_protect
    if session[:club_id]
      @current_membership = Membership.find_by_user_id_and_club_id(session[:user_id], session[:club_id], :conditions => ["status=?", "current"])
      if session[:user_id] == 6
        @current_membership = true
      end
      
      if !@current_membership 
        flash[:notice] = "Sorry, the page you were trying to access is only for approved " + Club.find(session[:club_id]).initials + " members.<BR />Request membership below."
        redirect_to club_memberships_path(session[:club_id])
        return false
      end
    end
    
    
  end
  
  def make_profile_vars
    @blog = @user.blog ||= Blog.new
    @posts = @blog.blogposts                # This is the key to refactoring the committee better.

  end
  
  
  private
  
  before_filter :instantiate_controller_and_action_names
  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end
  
end
