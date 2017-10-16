class UserController < ApplicationController
  include ApplicationHelper
  helper :avatar, :clubavatar
  before_filter :protect, :only => [:index , :edit, :show_duplicates, :purge_duplicates]
  
  def index 
    @user = User.find(session[:user_id])
    redirect_to_forwarding_url(@user)
  end

  def register
  	session[:club_id] = nil
    @title = "TheClubHut: Register"
    if param_posted?(:user)
      
      @user = User.new(params[:user])
      if @user.save 
        @user.login!(session)
        flash[:notice] = "User #{@user.firstname} created!"
        redirect_to_forwarding_url(@user)
      else
        @user.clear_password!
      end
    end
  end

  def login
    @title = "TheClubHut: Log In"
    session[:club_id] = nil
    if request.get?    
      @user = User.new(:remember_me => remember_me_string)
    elsif param_posted?(:user)
      @user = User.new(params[:user])
      # Encrypt the password supplied and compare it to the one used to log in.
      @user.password = MD5.new(@user.password).to_s unless @user.password.to_s =~ /^[\dabcdef]{32}$/

      user = User.find_by_email_and_password(@user.email, @user.password) 
      if user
        user.login!(session)
        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
        flash[:notice] = "#{user.firstname} logged in!"
        redirect_to_forwarding_url(user)
      else 
        @user.clear_password!
        flash[:notice] = "Invalid email/password combination"
      end
    end
  end
  
  def logout
    User.logout!(session, cookies)
    flash[:notice] = "Logged out"
    session[:club_id] = nil
    redirect_to :action => "index", :controller => "site"
  end

# Edit the user's basic info.
  def edit
  	session[:club_id] = nil
    @title = "TheClubHut: Edit Your Profile"
    @user = User.find(session[:user_id])   
    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
      when "screen_name"
        try_to_update @user, attribute
      when "email"
        try_to_update @user, attribute
      when "password"
        if @user.correct_password?(params)
          @user.password_reset = 0
          try_to_update @user, attribute
        else
          @user.password_errors(params)
        end  
      end
    end
    # For security purposes, never fill in password fields.
    @user.clear_password!
  end


def show_duplicates
	# This look up is for a view page to show all entries in the user database which have the same firstname and surname. 
	# If these are all bogus (spam) then they can be deleted with the purge function below.
	@title = "Show duplicate firstname / surname users"
	@remainingusers = User.find(:all, :order => "id ASC")
end

def purge_duplicates
	# Check NB logged in.
	if session[:user_id] == 6
	  	@listofusers = User.find(:all, :order => "id ASC")
		@listofusers.each do |u|
			if u.id != 784
				if (u.firstname == u.surname)
					# Delete duplicates.
					@user = User.find(u.id)
					@user.destroy
				end
			end
	end
	    flash[:notice] = 'Duplicate entries purged from user table.'
		redirect_to :controller => "profile", :action => "show", :id => 6
	else
	    flash[:notice] = 'Only the logged in webmaster is authorised to run a database purge of duplicate users.'
		redirect_to :controller => "site", :action => "index"
	end
 end
    
private
  # Redirect to the previously requested URL (if present).
  def redirect_to_forwarding_url(user)
    if user.password_reset == 1
      flash[:notice] = "You have recently reset your password. Change it to a more memorable one below."
      redirect_to :controller => "user", :action => "edit", :id => user.id
    else
      if (redirect_url = session[:protected_page])
        session[:protected_page] = nil
        redirect_to redirect_url
      else
        redirect_to :controller => "profile", :action => "show", :id => user.id
      end  
    end
  end
  
  # Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end
  
  # Try to update the user, redirecting if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
      flash[:notice] = "#{attribute} updated."
      redirect_to :action => "index"
    end
  end
  

  	
  
end
