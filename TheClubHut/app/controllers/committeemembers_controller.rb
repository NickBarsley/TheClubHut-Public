class CommitteemembersController < ApplicationController
  helper :clubavatar
  
  # GET /committeemembers
  # GET /committeemembers.xml
  def index
    @committeemembers = Committeemember.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @committeemembers }
    end
  end

  # GET /committeemembers/1
  # GET /committeemembers/1.xml
  def show
    @committeemember = Committeemember.find(params[:id])
    @club = Club.find(params[:club_id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @committeemember }
    end
  end

  # GET /committeemembers/new
  # GET /committeemembers/new.xml
  def new
    @committeemember = Committeemember.new
    @clubusers = User.find(:all, :order => "surname ASC")
    @title = "Create New Committee Member"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @committeemember }
    end
  end

  # GET /committeemembers/1/edit
  def edit
    @committeemember = Committeemember.find(params[:id])
    @clubusers = User.find(:all, :order => "surname ASC")    
  end

  # POST /committeemembers
  # POST /committeemembers.xml
  def create
    @committeemember = Committeemember.new(params[:committeemember])

    respond_to do |format|
      if @committeemember.save
        flash[:notice] = 'Committeemember was successfully created.'
        format.html { redirect_to(club_committees_path(params[:club_id])) }
        format.xml  { render :xml => @committeemember, :status => :created, :location => @committeemember }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @committeemember.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /committeemembers/1
  # PUT /committeemembers/1.xml
  def update
    @committeemember = Committeemember.find(params[:id])

    respond_to do |format|
      if @committeemember.update_attributes(params[:committeemember])
        flash[:notice] = 'Committeemember was successfully updated.'
        format.html { redirect_to(club_committees_path(params[:club_id])) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @committeemember.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /committeemembers/1
  # DELETE /committeemembers/1.xml
  def destroy
    @committeemember = Committeemember.find(params[:id])
    @committeemember.destroy

    respond_to do |format|
      format.html {  redirect_to(club_committees_path(params[:club_id]))  }
      format.xml  { head :ok }
    end
  end
end
