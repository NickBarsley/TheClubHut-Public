class PhotosController < ApplicationController
  helper :clubavatar
  before_filter :protect, :except => [:index , :show]
  require 'rubygems'
  require 'RMagick'
  include Magick
  
  # GET /photos
  # GET /photos.xml
  def index
    if params[:race_id]
      @event = Event.find(params[:event_id])
      @race = Race.find(params[:race_id])
      @photos = @race.photos.find(:all, :conditions => {:parent_id => nil }, :order => 'created_at DESC')
      if @event.ind_or_team == "Individual"
        @title = @event.title + " " + @event.date.year.to_s + ": " + @race.user.full_name + " Photos"    
      elsif @event.ind_or_team == "Team"
        @title = @event.title + " " + @event.date.year.to_s + ": " + @race.team.description + " Photos"    
      end
    elsif params[:team_id]
      @team = Team.find(params[:team_id])
      @photos = @team.photos.find(:all, :conditions => {:parent_id => nil }, :order => 'created_at DESC')
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    if params[:race_id]    
      @photo = Photo.find_by_race_id_and_id(params[:race_id], params[:id], :include => :race)
      @event = Event.find(params[:event_id])
      @race = Race.find(params[:race_id])

      if @event.ind_or_team == "Individual"
        @title = "New Photo  for " + @event.title + " " + @event.date.year.to_s + ": " + @race.user.full_name
      elsif @event.ind_or_team == "Team"
        @title = "New Photo  for " + @event.title + " " + @event.date.year.to_s + ": " + @race.team.description
      end

    elsif params[:item_id]
      @item = Item.find(params[:item_id])
      @photo = Photo.find_by_item_id_and_id(params[:item_id], params[:id])      
      @title = "Photo for: " + @item.name      

    elsif params[:team_id]
      @team = Team.find(params[:team_id])
      @photo = Photo.find_by_team_id_and_id(params[:team_id], params[:id])      
      @title = "Photo for: " + @team.description

    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    if params[:race_id]    
      @event = Event.find(params[:event_id])
      @race = Race.find(params[:race_id])
      @photo = Photo.new

      
      if @event.ind_or_team == "Individual"
        @title = "New Photo  for " + @event.title + " " + @event.date.year.to_s + ": " + @race.user.full_name
      elsif @event.ind_or_team == "Team"
        @title = "New Photo  for " + @event.title + " " + @event.date.year.to_s + ": " + @race.team.description
      end
      
    elsif params[:item_id]
      @item = Item.find(params[:item_id])
      @photo = Photo.new
      @title = "New Photo: " + @item.name

    elsif params[:team_id]
      @team = Team.find(params[:team_id])
      @photo = Photo.new
      @title = "New Photo: " + @team.description
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit

    if params[:race_id]
      @photo = Photo.find_by_race_id_and_id(params[:race_id], params[:id], :include => :race)    
      @race = Race.find(params[:race_id])
      @event = Event.find(params[:event_id])
      @title = "Edit " + @event.title + " " + @event.date.year.to_s + ": " + @race.team.description + " Photo"
    elsif params[:item_id]
      @item = Item.find(params[:item_id])
      @title = "Edit Photo: " + @item.name      
    elsif params[:team_id]
      @team = Team.find(params[:team_id])
      @photo = Photo.find_by_team_id_and_id(params[:team_id], params[:id])    
      @title = "Edit Photo: " + @team.description
    end
  end

  # POST /photos
  # POST /photos.xml
  def create
    if params[:race_id]    
      @race = Race.find(params[:race_id])
      @photo = Photo.new(params[:photo])
      goto = event_race_photos_path
    elsif params[:item_id]
      @item = Item.find(params[:item_id])
      @photo = Photo.new(params[:photo])
      goto = item_path(@item)
    elsif params[:team_id]
      @team = Team.find(params[:team_id])
      @photo = Photo.new(params[:photo])
      goto = team_path(@team)
    end

    if @photo.save
      respond_to do |format|
      flash[:notice] = 'Photo was successfully uploaded.'
      format.html { redirect_to goto }
    end
    else
      render :action => :new
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(event_race_photo_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    if params[:race_id]   
      respond_to do |format|
        format.html { redirect_to(event_race_photos_url) }
        format.xml  { head :ok }
      end
    elsif params[:item_id]
      respond_to do |format|
        format.html { redirect_to(item_url(params[:item_id])) }
        format.xml  { head :ok }
      end
    elsif params[:team_id]
      respond_to do |format|
        format.html { redirect_to(team_url(params[:team_id])) }
        format.xml  { head :ok }
      end      
    end
  end
end
