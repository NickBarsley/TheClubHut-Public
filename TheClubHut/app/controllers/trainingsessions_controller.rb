class TrainingsessionsController < ApplicationController
  # GET /trainingsessions
  # GET /trainingsessions.xml
  def index
    @trainingsessions = Trainingsession.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trainingsessions }
    end
  end

  # GET /trainingsessions/1
  # GET /trainingsessions/1.xml
  def show
    @trainingsession = Trainingsession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trainingsession }
    end
  end

  # GET /trainingsessions/new
  # GET /trainingsessions/new.xml
  def new
    @title = "Create a New Training Session"
    session[:interval_order] = nil
    @trainingsession = Trainingsession.new
    @trainingsession.interval.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trainingsession }
    end
  end

  # GET /trainingsessions/1/edit
  def edit
    session[:interval_order] = nil
    @trainingsession = Trainingsession.find(params[:id])
  end

  # POST /trainingsessions
  # POST /trainingsessions.xml
  def create
    @trainingsession = Trainingsession.new(params[:trainingsession])

    respond_to do |format|
      if @trainingsession.save
        flash[:notice] = 'Trainingsession was successfully created.'
        format.html { redirect_to(@trainingsession) }
        format.xml  { render :xml => @trainingsession, :status => :created, :location => @trainingsession }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trainingsession.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trainingsessions/1
  # PUT /trainingsessions/1.xml
  def update
    params[:trainingsession][:existing_interval_attributes] ||= {}
    @trainingsession = Trainingsession.find(params[:id])

    respond_to do |format|
      if @trainingsession.update_attributes(params[:trainingsession])
        flash[:notice] = 'Trainingsession was successfully updated.'
        format.html { redirect_to(@trainingsession) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trainingsession.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trainingsessions/1
  # DELETE /trainingsessions/1.xml
  def destroy
    @trainingsession = Trainingsession.find(params[:id])
    @trainingsession.destroy

    respond_to do |format|
      format.html { redirect_to(trainingsessions_url) }
      format.xml  { head :ok }
    end
  end
end
