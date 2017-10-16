class ForumsController < ApplicationController
	before_filter :login_required, :except => [:index, :show]
  before_filter :find_or_initialize_forum, :except => :index
	before_filter :admin?, :except => [:show, :index]
  helper :avatar, :clubavatar
  include ApplicationHelper 
  
  cache_sweeper :posts_sweeper, :only => [:create, :update, :destroy]

  def index
    
    @title = "Forums"
    
    @user = User.find_by_id(session[:user_id].to_i)
    if session[:user_id] != nil
        data = {    "name" => @user.firstname + "'s Coaching Feedback", 
                    "description" => "This forum contains feedback from your coaches. Only you and your club coaches can see the posts in this forum.",
                    "topics_count" => 0,
                    "posts_count" => 0,
                    "position" => 1,
                    "description_html" => "<p>This forum contains feedback from your coaches. Only you and your club coaches can see the posts in this forum.</p>",
                    "user_id" => session[:user_id].to_i }
      @coachingfeedback = @user.forum ||= Forum.new(data)
      @coachingfeedback.save
    end
    
    @memberships = Membership.find(:all, :select => "distinct(club_id)", :conditions => ["user_id=?", session[:user_id].to_i])
    
    # reset the page of each forum we have visited when we go back to index
    session[:forum_page] = nil
    respond_to do |format|
      format.html
      format.xml { render :xml => @forums }
    end
  end

  def show
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this forum for activity indicators
        (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?
        (session[:forum_page] ||= Hash.new(1))[@forum.id] = params[:page].to_i if params[:page]

        if allowed_to_view_forum(@forum, session[:user_id])
          flash[:notice] = "You do not have access to this forum."
          redirect_to forums_path
        end
        
        @topics = @forum.topics.paginate :page => params[:page]
        @title = "Forum: " + @forum.name
        User.find(:all, :conditions => ['id IN (?)', @topics.collect { |t| t.replied_by }.uniq]) unless @topics.blank?
      end
      format.xml { render :xml => @forum }
    end
  end

  # new renders new.html.erb  
  def create
    @forum.attributes = params[:forum]
    @forum.save!
    respond_to do |format|
      format.html { redirect_to @forum }
      format.xml  { head :created, :location => formatted_forum_url(@forum, :xml) }
    end
  end

  def new
    @title = "New Forum"
  end

  def newclub
    @club = Club.find(session[:club_id])
    @title = "New Forum for " + @club.initials
  end

  def update
    @forum.update_attributes!(params[:forum])
    respond_to do |format|
      format.html { redirect_to @forum }
      format.xml  { head 200 }
    end
  end
  
  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end
  
  protected
    def find_or_initialize_forum
      @forum = params[:id] ? Forum.find(params[:id]) : Forum.new
    end

    alias authorized? admin?
end
