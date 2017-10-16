class TeammembersController < ApplicationController
  helper :profile, :avatar, :clubavatar
  include ProfileHelper, AvatarHelper
  before_filter :load_team
  
  # GET /teammembers
  # GET /teammembers.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teammembers }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @teammember = Teammember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teammembers/new
  # GET /teammembers/new.xml
  def new
    @teammember = Teammember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teammember }
    end
  end

  # GET /teammembers/1/edit
  def edit
    @teammember = Teammember.find(params[:id])
  end

  # POST /teammembers
  # POST /teammembers.xml
  def create
    @teammember = Teammember.new(params[:teammember])

    respond_to do |format|
      if @teammember.save
        flash[:notice] = 'Teammember was successfully created.'
        format.html { redirect_to(season_teams_path) }
        format.xml  { render :xml => @teammember, :status => :created, :location => @teammember }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teammember.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teammembers/1
  # PUT /teammembers/1.xml
  def update
    @teammember = Teammember.find(params[:id])

    respond_to do |format|
      if @teammember.update_attributes(params[:teammember])
        flash[:notice] = 'Teammember was successfully updated.'
        format.html { redirect_to(season_teams_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teammember.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teammembers/1
  # DELETE /teammembers/1.xml
  def destroy
    @teammember = Teammember.find(params[:id])
    @teammember.destroy

    respond_to do |format|
      format.html { redirect_to(season_teams_path) }
      format.xml  { head :ok }
    end
  end
  
  def load_team
    @team = Team.find(params[:team_id]) 
  end 
  
end



