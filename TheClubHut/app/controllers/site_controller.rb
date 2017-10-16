class SiteController < ApplicationController


  def index 
    @title = "sipbib"
    session[:club_id] = nil
    @latestnews = Whatshappening.find(:all, :order => "created_at DESC")
    redirect_to club_staticpage_path(8, 83)
  
  end
  
  def about
    @title = "sipbib: about"
    session[:club_id] = nil
  end
  
  def help 
    @title = "sipbib: help"
    session[:club_id] = nil
  end
  

end
