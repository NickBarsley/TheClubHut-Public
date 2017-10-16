class AvatarController < ApplicationController
  before_filter :protect

  def index
        redirect_to :action => "index", :controller => "user"
  end

  def upload
    @title = "Upload Your Profile Photo"
    @user = User.find(session[:user_id])
    if param_posted?(:avatar)
      image = params[:avatar][:image]
      @avatar = Avatar.new(@user, image)
      if @avatar.save
        flash[:notice] = "Your profile photo has been uploaded."
        redirect_to :action => "index", :controller => "user"
      end
    end
  end
  
  # Delete the avatar.
  def delete
    user = User.find(session[:user_id])
    user.avatar.delete
    flash[:notice] = "Your profile photo been deleted."
        redirect_to :action => "index", :controller => "user"
  end
end