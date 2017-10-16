class ProfileController < ApplicationController
  helper :avatar, :friendship, :clubavatar
  before_filter :protect 

  def index
    @user = User.find(session[:user_id])    
    redirect_to :controller => "profile", :action => "show", :id => @user.id
  end

   def show
    
     if params[:id] != nil
       current_user_id = params[:id].to_i
     else
       flash[:notice] = "Error, no user specified."
     end
     
      
     @user = User.find_by_id(current_user_id)
     if session[:user_id].to_i == params[:id].to_i
      session[:club_id] = nil
     end
     
    @spec = @user.spec ||= Spec.new
    make_profile_vars
    @title = "#{@user.firstname} #{@user.surname}"  
    @youritems = Item.find(:all, :conditions => ["user_id=?", current_user_id], :include => :review)
    @newspage = false
    
    # Find every race that the user has been in. This can be refactored to be faster for sure!
    @teammembers = Teammember.find(:all, :conditions => ["user_id=?", current_user_id])
    @allraces = Array.new
    @teammembers.each do |teammember|
      @team=Team.find(teammember.team_id, :order=>"season_id DESC")
        @races=Race.find(:all, :conditions=>["team_id=?", teammember.team_id])
        @races.each do |race|
          @allraces << race
        end
    end
    # Sort the races into Chronological order.          
    @allevents = Array.new
    @allevents = @allraces.sort_by { |race| race.event.date }.reverse!
  end
 

def import_xml
  if params[:document]
    require 'rexml/document'
    file=params[:document][:file]
    doc=REXML::Document.new(file.read)
    doc.root.each_element('//tag') do |tag|
      @race = Race.new
      @race.update_attributes(tag.attributes)
    end
      redirect_to :controller => 'profile', :action => 'show'
  end

end




  def kitlocker
    @logged_in_user = User.find(session[:user_id]) if logged_in?
    # TO DO!
    # What if an invalid ID ? ?
    if params[:id]
        profile_viewed_matches_login?(params[:id], session[:user_id])
        @user = User.find_by_id(params[:id])
        @spec = @user.spec ||= Spec.new
        make_profile_vars
        @title = "#{@user.firstname} #{@user.surname}"  
        
        @youritems = Item.find(:all, :conditions => ["user_id=?", params[:id]], :include => :review)

        @teammembers = Teammember.find(:all, :conditions => ["user_id=?", params[:id]])

        @teams = Team.find(:all, :conditions => ["user_id=?", params[:id]], :include => [:teammember] )
    @newspage = false
        
    else
        @user = User.find(session[:user_id])
    end
  end



  def friends
    @logged_in_user = User.find(session[:user_id]) if logged_in?
    # TO DO!
    # What if an invalid ID ? ?
    if params[:id]
        profile_viewed_matches_login?(params[:id], session[:user_id])
        @user = User.find_by_id(params[:id])
        @spec = @user.spec ||= Spec.new
        make_profile_vars
        @title = "#{@user.firstname} #{@user.surname}"  
        
        @youritems = Item.find(:all, :conditions => ["user_id=?", params[:id]], :include => :review)

        @teammembers = Teammember.find(:all, :conditions => ["user_id=?", params[:id]])

        @teams = Team.find(:all, :conditions => ["user_id=?", params[:id]], :include => [:teammember] )
    @newspage = false
        
    else
        @user = User.find(session[:user_id])
    end
  end


  def blog
    @logged_in_user = User.find(session[:user_id]) if logged_in?
    # TO DO!
    # What if an invalid ID ? ?
    if params[:id]
        profile_viewed_matches_login?(params[:id], session[:user_id])
        @user = User.find_by_id(params[:id])
        @spec = @user.spec ||= Spec.new
        make_profile_vars
        @title = "#{@user.firstname} #{@user.surname}"  
        
        @youritems = Item.find(:all, :conditions => ["user_id=?", params[:id]], :include => :review)

        @teammembers = Teammember.find(:all, :conditions => ["user_id=?", params[:id]])

        @teams = Team.find(:all, :conditions => ["user_id=?", params[:id]], :include => [:teammember] )
    @newspage = false
        
    else
        @user = User.find(session[:user_id])
    end
  end
  
  def aboutme
    
    @logged_in_user = User.find(session[:user_id]) if logged_in?
    # TO DO!
    # What if an invalid ID ? ?
    if params[:id]
        begin
          profile_viewed_matches_login?(params[:id], session[:user_id])
          @user = User.find_by_id(params[:id])
          @spec = @user.spec ||= Spec.new
          make_profile_vars
          @title = "#{@user.firstname} #{@user.surname}"  
          @newspage = false
        rescue
          flash[:notice] = "Oops! Sorry, the profile you are trying to view either doesn't exist, or has an error.<BR> A notification email of this error has been sent to the sipbib team."
          redirect_to :controller => "profile", :action => "show", :id => session[:user_id]
        end
    else

        @user = User.find(session[:user_id])
        redirect_to :controller => "profile", :action => "show", :id => @user.id
    end
  end
 
  
  
end
