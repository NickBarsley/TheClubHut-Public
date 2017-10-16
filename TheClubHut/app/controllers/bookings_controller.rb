class BookingsController < ApplicationController
  helper :avatar, :clubavatar
    
require 'date'
require 'rubygems'
  require 'active_support'

  # GET /bookings
  # GET /bookings.xml
  def index
    
    @booking = Booking.new
    
    if session[:club_id] != nil
    	@club = Club.find(session[:club_id])
	end
    
    if session[:booking_viewingweek] != nil
      # Already a date set to display.
    else
       currentDay = Date.today.strftime("%w")
       if currentDay == 0 
         currentDay = 7
       end
       session[:booking_viewingweek] = Date.today - (currentDay.to_i - 1).day
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bookings }
    end


  end



# GET /bookings/1
  # GET /bookings/1.xml
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.xml
  def new
    @booking = Booking.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.xml
  def create
    
    @booking = Booking.new(params[:booking])
    params[:booking][:end_time] = @booking.end_time
    

    
    @booking = Booking.new(params[:booking])
    if @booking.weights == 1
      @booking.no_ergs = 0
    end
    
    respond_to do |format|
      if @booking.save
          flash[:notice] = 'Your booking was successfully created.'
          format.html { redirect_to bookings_path }
          format.xml  { render :xml => @booking, :status => :created, :location => @booking }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.xml
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        flash[:notice] = 'Booking was successfully updated.'
        format.html { redirect_to(@booking) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.xml
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to(bookings_url) }
      format.xml  { head :ok }
    end
  end
end
