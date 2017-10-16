class EventsController < ApplicationController
  include ApplicationHelper
  helper :application, :clubavatar
  before_filter :protect, :only => [:destroy, :update, :create, :edit, :new, :enter]
  before_filter :event_var_setup, :except => [:index, :description]
  
  # GET /events
  # GET /events.xml
  def index
    @pastevents = Event.find(:all, :order => "date DESC", :conditions => ["date<?", Date.today])
    @upcomingevents = Event.find(:all, :order => "date DESC", :conditions => ["date>=?", Date.today])
    @title = "All Events"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    if @event
      respond_to do |format|
        format.html { redirect_to(description_event_path(params[:id])) }
        format.xml  { render :xml => @event }
      end
    else
      respond_to do |format|
        format.html { 
        flash[:notice] = "That event does not exist in our database"
        redirect_to(events_path) }
        format.xml  { render :xml => @event }
      end
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
   
    @title = "Create a New Event"
    @event = Event.new
    @user = User.find(session[:user_id])

	# I need to give the event new form a list of all the clubs which the member belongs to.    
	@memberships = Membership.find(:all, :conditions => ["user_id=?", session[:user_id]])
  userclubs = Array.new
	for membership in @memberships
		userclubs << membership.club_id
	end
	@userclubs = userclubs.uniq!

    
    if club_page?
      @club = Club.find(session[:club_id])
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @clubs = Club.find(:all)
    @title = "Edit Event"    
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(description_event_path(@event.id)) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def report
    @event = Event.find(params[:id])
    @title = @event.title.to_s + " " + @event.date.year.to_s + ": Reports"
  end
  
  def description
  	if params[:id].to_i == 242
  		redirect_to( "http://www.srcf.ucam.org/qergs/" )
  	else
  	  	@event = Event.find(params[:id])
  	    @sport = DataSports.find(@event.sport_id)
  	    @user = User.find(@event.user_id)
  	    @dataetype = Dataetypes.find(@event.dataetype_id)
  	    @country = Datacountrys.find(@event.datacountry_id)
  	    @title = @event.title.to_s + " " + @event.date.year.to_s + ": Event Info"
  	end
  end
  
  def enter
    @event = Event.find(params[:id])
    if @event.dataetype_id != 1
      # Its not a social event.
      @teams = Team.find(:all, :conditions => ["user_id=?", session[:user_id]], :include => :teammember, :order => "season_id DESC")

      #@committee_of_clubs_list = committee_of_clubs(session[:user_id].to_i)
      if current_club_committee?
        @allteams = Array.new
        @club = Club.find(session[:club_id])
          @clubteams = Team.find(:all, :conditions => ["club_id=?", @club.id], :include => :teammember, :order => "season_id DESC")
          @clubteams.each do |team|
              @allteams << team
          end
      end
      
      @team = Team.new
      @team.teammember.build
      @club = Club.find_by_id(session[:club_id])
      # Refine this to allow club users only.
      @users = User.find(:all)
      
      
    end

    # Check here whether or not the user has already signed up for this event. If they have, redirect them back to the attendees list where they should see themselves. 
    signedinuserhasentered = false
    @event.race.each do |race|
      if race.user_id == session[:user_id]
        signedinuserhasentered = true
      end
    end
    if signedinuserhasentered == true and @event.ind_or_team == "Individual"
      flash[:notice] = "You have already entered this event!"
      redirect_to results_event_path(params[:id])
    end

    @race = Race.new
    @sport = DataSports.find(@event.sport_id)
    @user = User.find(@event.user_id)
    @dataetype = Dataetypes.find(@event.dataetype_id)
    @country = Datacountrys.find(@event.datacountry_id)
    @title = @event.title.to_s + " " + @event.date.year.to_s + ": SIGN UP"
  end


  def results
    @event = Event.find(params[:id])
    @races = Race.find(:all, :conditions => ["event_id=?", params[:id]], :order => "position ASC")
    @title = @event.title.to_s + " " + @event.date.year.to_s + ": Results"
  end

  def upcoming
    @events = Event.find(:all, :conditions => ["date>=?", Date.today], :order => "date ASC")
  end

  private
  def event_var_setup
    @sports = DataSports.find(:all, :order => "name ASC")
    @etypes = Dataetypes.find(:all, :order => "roworder ASC")
    @estatus = Dataestatuses.find(:all, :order => "roworder ASC")
    @countrys = Datacountrys.find(:all, :order => "name ASC")
  end
end
