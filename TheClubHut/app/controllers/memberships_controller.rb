class MembershipsController < ApplicationController
  include ApplicationHelper, ProfileHelper
  helper :avatar, :clubavatar
  before_filter :protect, :except => [:index]
  before_filter :setup_memberships, :except => [:index, :admin, :destroy ]

  # GET /memberships
  # GET /memberships.xml
  def index
    @memberships = Membership.find(:all)
    @club = Club.find(params[:club_id])
    session[:club_id] = params[:club_id].to_i
    @title = @club.initials + ": Members"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @memberships }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.xml
  def show
    respond_to do |format|
      format.html { redirect_to(club_memberships_path(@club)) }
      format.xml  { render :xml => @membership }
    end
  end

  def admin
    @user = User.find(session[:user_id])
    @memberships = Membership.find(:all, :conditions => ["user_id=?", session[:user_id]], :order => "club_id ASC")
    @title = "Your Memberships"
  end

  # GET /memberships/new
  # GET /memberships/new.xml
  def new
    @membership = Membership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @membership }
    end
  end

  # GET /memberships/1/edit
  def edit
    @membership = Membership.find(params[:id])
    @user = User.find(@membership.user_id)
    @club = Club.find(@membership.club_id)
  end

  # POST /memberships
  # POST /memberships.xml
  def create
    @membershiptype = Membershiptype.find_by_id(params[:membership][:membershiptype_id])
    @user = User.find(session[:user_id])
    @requester = @user
    @club = Club.find_by_id(@membershiptype.club_id)
    @membership = Membership.new(params[:membership])
    respond_to do |format|
      if Membership.find_by_user_id_and_membershiptype_id(@user, @membershiptype).nil?
        @membership.save

        toemail = Array.new
        # Email the committee of the club
        if @currentcommittee = Committee.find(:first, :conditions => [ "club_id=?", @club.id], :order => "in_office_from DESC")
          if @committeemembers = Committeemember.find(:all, :conditions => [ "committee_id=?", @currentcommittee.id])
            unless @committeemembers.empty?
              @committeemembers.each do |committeemember|
                toemail << committeemember.user.id
              end
            end
          end
        end
        
        toemail.each do |user|
          @user = User.find_by_id(user)
          UserMailer.deliver_membershiprequest(@requester, @user, @membershiptype, @club)
        end
        
        flash[:notice] = "Your request for the membership status of \"" + @membershiptype.name + "\" with " + @club.name + " has been made successfully."
        format.html { redirect_to(club_memberships_path(@club)) }
        format.xml  { render :xml => @membership, :status => :created, :location => @membership }
      else
        flash[:notice] = "You already have the membership status of \"" + @membershiptype.name + "\" with " + @club.name + "."
        format.html { render :action => "index" }
        format.xml  { render :xml => @membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memberships/1
  # PUT /memberships/1.xml
  def update
    @membership = Membership.find(params[:id])
    session[:club_id] = @membership.club_id
    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        flash[:notice] = 'Membership was successfully updated.'
        format.html { redirect_to(club_memberships_path(@club)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.xml
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy

    respond_to do |format|
      flash[:notice] = 'Membership successfully deleted.'
      format.html { redirect_to(admin_memberships_path) }
      format.xml  { head :ok }
    end
  end
  
  def accept
    @membership = Membership.find(params[:id])
    @membership.status = "granted"
    @membership.accepted_at = Time.now
    
    respond_to do |format|
      if @membership.save
        flash[:notice] = 'Membership was successfully updated.'
        format.html { redirect_to(club_memberships_url) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(club_memberships_url) }
        format.xml  { render :xml => @membership.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private 
  def setup_memberships
    if session[:user_id] != nil
        @user = User.find(session[:user_id])
    else
      flash[:notice] = "Error, not logged in."
    end
    
    if session[:club_id] != nil
      @club = Club.find(session[:club_id])
    elsif params[:club_id]
      @club = Club.find(params[:club_id])
    elsif params[:membership][:club_id]
      @club = Club.find(params[:membership][:club_id])
    end
    
  end
end
