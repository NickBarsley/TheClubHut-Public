class TeamsController < ApplicationController
  before_filter :protect, :only => [:teamemail]
  
  helper :profile, :avatar, :clubavatar
  include ProfileHelper, AvatarHelper
  
  # GET /teams
  # GET /teams.xml
  def index
    club_id = session[:club_id]
    @club = Club.find_by_id(session[:club_id])
    
    @title = @club.name + ": Crews"
    @teams = Team.find(:all, :conditions => ["club_id=? and season_id=?", club_id, params[:season_id]], :order => "season_id DESC, roworder DESC")
    @seasons = Season.find(params[:season_id])    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
    @races=Race.find(:all, :conditions=>["team_id=?", @team.id], :include => :event, :order => "date DESC")
    
    @title = @team.description
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    
    if session[:club_id] == nil
      flash[:notice] = "In order to create a team you need to: <ol><li>Be a member of a club.</LI><li>AND be looking at one of their sipbib pages. </li></ol>Below are the clubs hosted on sipbib.com"
      redirect_to(:controller => "clubs", :action => "index") and return false
    end
    @club = Club.find_by_id(session[:club_id])
    @team = Team.new
    @team.teammember.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(team_path(@team)) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    params[:team][:existing_teammember_attributes] ||= {}
    
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(team_path(@team)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(season_url(@team.season_id)) }
      format.xml  { head :ok }
    end
  end
  
  def teamemail
    @team = Team.find(params[:id])
    if !current_team(params[:id]) and !current_club_committee?
      flash[:notice] = "You do not have access to email this team."
      redirect_to team_path(@team.id)
    else
      @title = "Send an email to: " + @team.description
    end
  end

  def teamforum
    @team = Team.find(params[:id])
    @teamforum = Forum.find(:all, :conditions => ["team_id=?", params[:id]])
    if @teamforum.size == 0
      data = {    "name" => @team.description, 
                  "description" => "This forum is for members of the " + @team.description + " only.",
                  "topics_count" => 0,
                  "posts_count" => 0,
                  "team_id" => @team.id,
                  "description_html" => "<p>This forum is for members of the " + @team.description + " only.</p>",
                  "club_id" => @team.club_id }
      @teamforum = Forum.new(data)
      @teamforum.save
      
      # Notify the crew that the forum has been created.
      @sender =  User.find(session[:user_id])
      numrecipients = @team.teammember.size
      
      emailsubject = @team.description + " Team Forum Created!"
      @team.teammember.each do |teammember|
        emailbody = "A new forum has been created for the " + @team.description + " on the " + @team.club.name + " website. It is exclusively for you and your team mates use. Follow this link to view the forum: http://www.sipbib.com/forums/" + @teamforum.id.to_s + "."
        UserMailer.deliver_teamemail(teammember.user, @sender, @team, emailbody, emailsubject, numrecipients)
      end
      flash[:notice] = "Your team forum has been successfully created. Your team mates have been emailed to let them know it exists."
      
    else
      # A forum already exists.
    end

    redirect_to forum_path(@teamforum)
  end
  
end
