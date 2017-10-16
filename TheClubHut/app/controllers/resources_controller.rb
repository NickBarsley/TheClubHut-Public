require 'vendor/plugins/gcalapi/lib/gcalapi'
require 'date'
require 'time'

REQUEST_URL = "https://www.google.com/accounts/AuthSubRequest"
SESSION_URL = "https://www.google.com/accounts/AuthSubSessionToken"
REVOKE_URL = "https://www.google.com/accounts/AuthSubRevokeToken"
INFO_URL = "https://www.google.com/accounts/AuthSubTokenInfo"
CALENDAR_SCOPE = "http://www.google.com/calendar/feeds/"
DEFAULT_CALENDAR_FEED = "http://www.google.com/calendar/feeds/default/private/full"
MAIL = "nickbarsley@cantab.net"
PASS = "Qpwals0)"

class ResourcesController < ApplicationController
  before_filter :club_protect, :except => [:index]
  helper :clubavatar
  # GET /resources
  # GET /resources.xml
  def index
    @resources = Resource.find(:all)
    @title = "QCBC Bookable Resources"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.xml
  def show
    @resource = Resource.find(params[:id])
    @booking = Booking.new
    @title = @resource.name + " Bookings"

    # I set the below so that I can find the right resource from the booking to delete.
    session[:resource_id] = @resource.id

    srv = GoogleCalendar::Service.new(MAIL, PASS)
    cal = GoogleCalendar::Calendar.new(srv, @resource.feed)
    @event = cal.events

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.xml
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.xml
  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        flash[:notice] = 'Resource was successfully created.'
        format.html { redirect_to(@resource) }
        format.xml  { render :xml => @resource, :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.xml
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        flash[:notice] = 'Resource was successfully updated.'
        format.html { redirect_to(@resource) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end
end
