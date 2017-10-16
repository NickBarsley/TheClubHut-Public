class MembershiptypesController < ApplicationController
  # GET /membershiptypes
  # GET /membershiptypes.xml
  def index
    @club = Club.find_by_id(session[:club_id])
    @membershiptypes = Membershiptype.find(:all, :conditions => ["club_id=?", @club])
    @title = @club.name + " Membership Types"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @membershiptypes }
    end
  end

  # GET /membershiptypes/1
  # GET /membershiptypes/1.xml
  def show
    @membershiptype = Membershiptype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @membershiptype }
    end
  end

  # GET /membershiptypes/new
  # GET /membershiptypes/new.xml
  def new
    @membershiptype = Membershiptype.new
    @club = Club.find_by_id(session[:club_id])
    @title = "Create a New Membership Type for " + @club.name
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @membershiptype }
    end
  end

  # GET /membershiptypes/1/edit
  def edit
    @membershiptype = Membershiptype.find(params[:id])
        @club = Club.find_by_id(session[:club_id])
    @title = "Edit Membership Type for " + @club.name
  end

  # POST /membershiptypes
  # POST /membershiptypes.xml
  def create
    @membershiptype = Membershiptype.new(params[:membershiptype])

    respond_to do |format|
      if @membershiptype.save
        flash[:notice] = 'Membershiptype was successfully created.'
        format.html { redirect_to membershiptypes_path }
        format.xml  { render :xml => @membershiptype, :status => :created, :location => @membershiptype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @membershiptype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /membershiptypes/1
  # PUT /membershiptypes/1.xml
  def update
    @membershiptype = Membershiptype.find(params[:id])

    respond_to do |format|
      if @membershiptype.update_attributes(params[:membershiptype])
        flash[:notice] = 'Membershiptype was successfully updated.'
        format.html { redirect_to membershiptypes_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @membershiptype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /membershiptypes/1
  # DELETE /membershiptypes/1.xml
  def destroy
    @membershiptype = Membershiptype.find(params[:id])
    @membershiptype.destroy

    respond_to do |format|
      format.html { redirect_to(membershiptypes_url) }
      format.xml  { head :ok }
    end
  end
end
