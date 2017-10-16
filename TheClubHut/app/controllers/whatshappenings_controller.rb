class WhatshappeningsController < ApplicationController
  # GET /whatshappenings
  # GET /whatshappenings.xml
  def index
    @whatshappenings = Whatshappening.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @whatshappenings }
    end
  end

  # GET /whatshappenings/1
  # GET /whatshappenings/1.xml
  def show
    @whatshappening = Whatshappening.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @whatshappening }
    end
  end

  # GET /whatshappenings/new
  # GET /whatshappenings/new.xml
  def new
    @whatshappening = Whatshappening.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @whatshappening }
    end
  end

  # GET /whatshappenings/1/edit
  def edit
    @whatshappening = Whatshappening.find(params[:id])
  end

  # POST /whatshappenings
  # POST /whatshappenings.xml
  def create
    @whatshappening = Whatshappening.new(params[:whatshappening])

    respond_to do |format|
      if @whatshappening.save
        flash[:notice] = 'Whatshappening was successfully created.'
        format.html { redirect_to(@whatshappening) }
        format.xml  { render :xml => @whatshappening, :status => :created, :location => @whatshappening }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @whatshappening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /whatshappenings/1
  # PUT /whatshappenings/1.xml
  def update
    @whatshappening = Whatshappening.find(params[:id])

    respond_to do |format|
      if @whatshappening.update_attributes(params[:whatshappening])
        flash[:notice] = 'Whatshappening was successfully updated.'
        format.html { redirect_to(@whatshappening) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @whatshappening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /whatshappenings/1
  # DELETE /whatshappenings/1.xml
  def destroy
    @whatshappening = Whatshappening.find(params[:id])
    @whatshappening.destroy

    respond_to do |format|
      format.html { redirect_to(whatshappenings_url) }
      format.xml  { head :ok }
    end
  end
end
