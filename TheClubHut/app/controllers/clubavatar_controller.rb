class ClubavatarController < ApplicationController
  before_filter :protect

  def index
    redirect_to :controller => "clubs", :action => "show", :id => @club.id
  end

  def upload
    @title = "Upload A Club Logo"
    @club = Club.find(session[:club_id])
    if param_posted?(:clubavatar)
      image = params[:clubavatar][:image]
      @avatar = Clubavatar.new(@club, image)
      if @avatar.save
        flash[:notice] = "Your club logo has been uploaded."
        redirect_to :controller => "clubs", :action => "show", :id => @club.id
      end
    end
  end
  
  # Delete the avatar.
  def delete
    club = Club.find(session[:club_id])
    club.clubavatar.delete
    flash[:notice] = "Your club logo been deleted."
        redirect_to :controller => "clubs", :action => "show", :id => session[:club_id]
  end
end
