class ClubsController < ApplicationController
  before_filter :protect, :only => [:new , :edit, :update, :create, :admin, :destroy]
  helper :profile, :avatar, :clubavatar
  include ProfileHelper, AvatarHelper
  
  # GET /clubs
  # GET /clubs.xml
  def index
    @clubs = Club.find(:all, :order => "name ASC")
    @title = "List of Clubs"
    session[:club_id] = nil
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clubs }
    end
  end


  def news
    @club = Club.find(params[:id])
    session[:club_id] = @club.id
    @blog = @club.blog ||= Blog.new
    @posts = @blog.blogposts
    session[:club_initials] = @club.initials.split("")
    @newspage = true
    @title = @club.name + " News"    

  end
  
  def show
    begin
        session[:club_id] = params[:id]
        @firstpage = Navigation.find(:first, :conditions => ["club_id=? AND firstpage=?", session[:club_id], 1])
        if @firstpage != nil
          redirect_to club_staticpage_path(session[:club_id].to_i, @firstpage.staticpage_id.to_i) 
          return false
        else
          redirect_to :controller => :clubs, :action => :news, :id => session[:club_id]
          return false
        end
    rescue
        # This is not a valid club.
        flash[:notice] = "The club you have tried to view does not exist."
        redirect_to :controller => :clubs, :action => :index
        return false
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @club }
    end
  end

  # GET /clubs/new
  # GET /clubs/new.xml
  def new
    @club = Club.new
    @title = "Create a New Club"
    session[:club_id] = nil
    
    @dynpage={ "0" => "Club News",
              "1" => "Committee",
              "2" => "Members"}

    @dynpath={ "0" => "news_club_path(session[:club_id])",
              "1" => "club_committees_path(session[:club_id])",
              "2" => "club_memberships_path(session[:club_id])"}
              
    for dynamic in @dynpage
      @club.navigation.build
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
    @title = "Edit Club"
  end

  # POST /clubs
  # POST /clubs.xml
  def create
    @club = Club.new(params[:club])
    @club.backgroundcolor = "#" + @club.backgroundcolor

    respond_to do |format|
      if @club.save
        data = { "club_id" => @club.id,
        "name" => "Current Member",
        "name_plural" => "Current Members",
        "coachable" => 1,
        "description" => "current members of " + @club.initials }
        @membershiptype = Membershiptype.new(data)
        @membershiptype.save
        
        flash[:notice] = 'Club was successfully created.'
        format.html { redirect_to(@club) }
        format.xml  { render :xml => @club, :status => :created, :location => @club }
      else
            @dynpage={ "0" => "Club News",
              "1" => "Committee",
              "2" => "Members"}

    @dynpath={ "0" => "club_path(session[:club_id])",
              "1" => "club_committees_path(session[:club_id])",
              "2" => "club_memberships_path(session[:club_id])"}
              

        format.html { render :action => "new" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.xml
  def update
    @club = Club.find(params[:id])

    respond_to do |format|
      if @club.update_attributes(params[:club])
        flash[:notice] = 'Club was successfully updated.'
        format.html { redirect_to(@club) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.xml
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to(clubs_url) }
      format.xml  { head :ok }
    end
  end
  
  def admin
    @club = Club.find(params[:id])
    @title = @club.initials + " Website Administration Centre"
    @staticpages = Staticpage.find(:all, :conditions => ['club_id=?', params[:id]])
  end
  
  def listorder

  end
end
