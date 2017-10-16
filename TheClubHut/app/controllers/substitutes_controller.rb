class SubstitutesController < ApplicationController
  # GET /substitutes
  # GET /substitutes.xml
  def index
    @substitutes = Substitute.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @substitutes }
    end
  end

  # GET /substitutes/1
  # GET /substitutes/1.xml
  def show
    @substitute = Substitute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @substitute }
    end
  end

  # GET /substitutes/new
  # GET /substitutes/new.xml
  def new
    @substitute = Substitute.new
    # Bug to solve here - the member can visit another club and use that session club_id
    @users = User.find(:all, :conditions => ["club_id=? and status=?", session[:club_id], "granted"], :include => :membership, :order => "surname ASC")
    @team = Team.find_by_id(params[:team_id])
    @title = "Create a Substitute for " + @team.description
    @races = Race.find(:all, :conditions => ["team_id=?", params[:team_id]], :order => ["date DESC"], :include => :event)
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @substitute }
    end
  end

  # GET /substitutes/1/edit
  def edit
    @substitute = Substitute.find(params[:id])
  end

  # POST /substitutes
  # POST /substitutes.xml
  def create
    @substitute = Substitute.new(params[:substitute])

    respond_to do |format|
      if @substitute.save
        flash[:notice] = 'Substitute was successfully created.'
        format.html { redirect_to(team_path(@substitute.team_id)) }
        format.xml  { render :xml => @substitute, :status => :created, :location => @substitute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @substitute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /substitutes/1
  # PUT /substitutes/1.xml
  def update
    @substitute = Substitute.find(params[:id])

    respond_to do |format|
      if @substitute.update_attributes(params[:substitute])
        flash[:notice] = 'Substitute was successfully updated.'
        format.html { redirect_to(@substitute) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @substitute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /substitutes/1
  # DELETE /substitutes/1.xml
  def destroy
    @substitute = Substitute.find(params[:id])
    @substitute.destroy

    respond_to do |format|
      format.html { redirect_to(team_path(@substitute.team_id)) }
      format.xml  { head :ok }
    end
  end
end
