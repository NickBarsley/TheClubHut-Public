class SeasonsController < ApplicationController
  helper :clubavatar
  
  # GET /seasons
  # GET /seasons.xml
  def index
    @seasons = Season.find(:all, :order => "starts_from DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seasons }
    end
  end

def show
    club_id = session[:club_id]
    @club = Club.find_by_id(session[:club_id])
    @title = @club.name + ": Crews"
    @teams = Team.find(:all, :conditions => ["club_id=? and season_id=?", club_id, params[:id]], :order => "season_id DESC, roworder DESC")
    @seasons = Season.find(params[:id])    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
end

  # GET /seasons/new
  # GET /seasons/new.xml
  def new

    @season = Season.new
    @club = Club.find_by_id(session[:club_id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @season }
    end
  end

  # GET /seasons/1/edit
  def edit
    @season = Season.find(params[:id])
  end

  # POST /seasons
  # POST /seasons.xml
  def create
    @season = Season.new(params[:season])

    respond_to do |format|
      if @season.save
        flash[:notice] = 'Season was successfully created.'
        format.html { redirect_to( seasons_path) }
        format.xml  { render :xml => @season, :status => :created, :location => @season }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.xml
  def update
    @season = Season.find(params[:id])

    respond_to do |format|
      if @season.update_attributes(params[:season])
        flash[:notice] = 'Season was successfully updated.'
        format.html { redirect_to(seasons_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @season.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.xml
  def destroy
    @season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { redirect_to(seasons_url) }
      format.xml  { head :ok }
    end
  end
end
