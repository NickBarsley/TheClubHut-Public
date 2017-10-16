class StaticpagesController < ApplicationController
  helper :clubavatar
  before_filter :protect, :except => [:show]
  
  # GET /staticpages
  # GET /staticpages.xml
  def index
    @staticpages = Staticpage.find(:all, :conditions => ['club_id=?', params[:club_id]])
    @club = Club.find(params[:club_id])
    @title = "Admin: Static Pages for #{@club.initials}"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staticpages }
    end
  end

  # GET /staticpages/1
  # GET /staticpages/1.xml
  def show
    @staticpage = Staticpage.find(params[:id])
    @club = Club.find(params[:club_id])

    @blog = @club.blog ||= Blog.new
    @posts = @blog.blogposts
    
    @title = @staticpage.toolbar_title
    session[:club_id] = @club.id
    if @club.id.to_i == 8
      @latestnews = Whatshappening.find(:all, :order => "created_at DESC")
    else
      @latestnews = Whatshappening.find(:all, :conditions => ['club_id=?', session[:club_id]], :order => "created_at DESC")
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staticpage }
    end
  end

  # GET /staticpages/new
  # GET /staticpages/new.xml
  def new
    @club = Club.find(params[:club_id])
    @title = "Admin: Create Static Page for #{@club.initials}"
    
    @staticpage = Staticpage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staticpage }
    end
  end

  # GET /staticpages/1/edit
  def edit
    @staticpage = Staticpage.find(params[:id])
    @club = Club.find(params[:club_id])
    @title = "Admin: Edit Static Page for #{@club.initials}"    
  end

  # POST /staticpages
  # POST /staticpages.xml
  def create

    @staticpage = Staticpage.new(params[:staticpage])
      
    respond_to do |format|
      if @staticpage.save
            flash[:notice] = 'New page successfully created.'          
            format.html { redirect_to club_staticpage_path(session[:club_id], @staticpage.id) }
            format.xml  { render :xml => @staticpage, :status => :created, :location => @staticpage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staticpage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staticpages/1
  # PUT /staticpages/1.xml
  def update
    @staticpage = Staticpage.find(params[:id])

    respond_to do |format|
      if @staticpage.update_attributes(params[:staticpage])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to club_staticpage_path(session[:club_id], @staticpage.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staticpage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staticpages/1
  # DELETE /staticpages/1.xml
  def destroy
    @staticpage = Staticpage.find(params[:id])
    @staticpage.destroy

    respond_to do |format|
      flash[:notice] = 'Page was successfully deleted.'
      format.html { redirect_to(admin_club_url(session[:club_id])) }
      format.xml  { head :ok }
    end
  end
end
