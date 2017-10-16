class MediasController < ApplicationController

def show
	# Check we're on a club page and have a season ID in the params.
	if session[:club_id] != nil and Season.find(params[:id]) != nil
		@club = Club.find(session[:club_id])
		@season = Season.find(params[:id])
		@teams = Team.find(:all, :conditions => ["club_id=? and season_id=?", session[:club_id], params[:id]], :order => "season_id DESC, roworder DESC")
		
		@title = @club.initials + " photos for " + @season.description
	else
		# Something has gone wrong, no longer on a club page or don't have a valid season ID.
	end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @club }
    end

end



end
