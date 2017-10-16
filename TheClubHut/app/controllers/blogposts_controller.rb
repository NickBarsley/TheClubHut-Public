class BlogpostsController < ApplicationController
  helper :profile, :avatar, :clubavatar
  before_filter :protect, :protect_blog
  include Observable
  include ApplicationHelper
#  before_filter :protect_post, :only => [:show, :edit, :update, :destroy]
  
  # GET /posts
  # GET /posts.xml
  def index
        redirect_to :controller => "profile", :action => "show"
#    @posts = @blog.blogposts
#    @title = "Blog Management"
#
#    respond_to do |format|
#      format.html # index.rhtml
#      format.xml  { render :xml => @posts.to_xml }
#    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Blogpost.find(params[:id])
    @title = @post.title
    @newspage = false
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @post.to_xml }
    end
  end

  # GET /posts/new
  def new
    @post = Blogpost.new
    @title = "Add a new post"
  end

  # GET /posts/1;edit
  def edit
    @blogpost = Blogpost.find(params[:id])
    @title = "Edit #{@blogpost.title}"
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Blogpost.new(params[:blogpost])
    @post.blog = @blog
    
    respond_to do |format|
      if @blog.blogposts << @post 
        @club = Club.find(session[:club_id])
        @sender = User.find(@post.user_id)
        
        if params[:blogpost][:membershiptype_ids].nil?
          # don't do anything if they didn't want to email it out.
          flash[:notice] = "Your news story has been successfully posted online."
        else
          recipients = Array.new
          params[:blogpost][:membershiptype_ids].each do |type|
            @members = Membership.find(:all, :conditions => ["membershiptype_id=? and status=?", type, "granted"])
            @members.each do |member|
              recipients << member.user_id
            end      
          end
          recipients.uniq!
          recipients.size.times do |i|
            @user = User.find_by_id(recipients[i])
            thebody = html2text(@post.body)
            UserMailer.deliver_clubemail(@user, @club, @sender, thebody, @post.title)          
          end      
          flash[:notice] = "Your news story has been successfully posted and emailed to " + recipients.size.to_s + " recipients."
          
        end
      
        format.html { redirect_to news_club_path(session[:club_id]) }
        format.xml  { head :created, :location => blog_post_url(:id => @post) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end






  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @blogpost = Blogpost.find(params[:id])
    respond_to do |format|
      if @blogpost.update_attributes(params[:blogpost])
        flash[:notice] = 'News story was successfully updated.'
        format.html { redirect_to news_club_path(session[:club_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blogpost.errors.to_xml }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Blogpost.find(params[:id])
    @blog = @post.blog
    @post.destroy

    respond_to do |format|
      format.html { redirect_to news_club_path(@blog.club_id) }
      format.xml  { head :ok }
    end
  end
  
  private

  def html2text(html)
    text = html.
    gsub(/(&nbsp;|\n|\s)+/im, ' ').squeeze(' ').strip.
    gsub(/<([^\s]+)[^>]*(src|href)=\s*(.?)([^>\s]*)\3[^>]*>\4<\/\1>/i, '\4')
    links = []
    linkregex = /<[^>]*(src|href)=\s*(.?)([^>\s]*)\2[^>]*>\s*/i
    while linkregex.match(text)
      links << $~[3]
      text.sub!(linkregex, "[#{links.size}]")
    end
  
    text = CGI.unescapeHTML(
      text.
        gsub(/<(script|style)[^>]*>.*<\/\1>/im, '').
        gsub(/<!--.*-->/m, '').
        gsub(/<hr(| [^>]*)>/i, "___\n").
        gsub(/<li(| [^>]*)>/i, "\n* ").
        gsub(/<blockquote(| [^>]*)>/i, '> ').
        gsub(/<(br)(| [^>]*)>/i, "\n").
        gsub(/<(\/h[\d]+|p)(| [^>]*)>/i, "\n\n").
        gsub(/<[^>]*>/, '')
    ).lstrip.gsub(/\n[ ]+/, "\n") + "\n"
  
    for i in (0...links.size).to_a
      text = text + "\n  [#{i+1}] <#{CGI.unescapeHTML(links[i])}>" unless
      links[i].nil?
    end
    
    links = nil
    text
  end

  # Ensure that user is blog owner, and create @blog.
  def protect_blog
    @blog = Blog.find(params[:blog_id])
    user = User.find(session[:user_id])
    
    if @blog.club_id != nil
      #This is a club blog (ie News).
      if !current_club_committee?
        flash[:notice] = "You're not on the committee for this club, so I'm afraid you can't edit news. Sorry!"
        redirect_to :controller => "club", :action => "news"
        return false
      end
    else 
      # This is not a club blog. Its a Personal blog.
      if @blog.user != user
        flash[:notice] = "That isn't your blog!"
        redirect_to :controller => "profile", :action => "show"
      return false
      end
    end
  end

  
  def protect_post
    post = Blogpost.find(params[:id])    
    unless post.blog == @blog
      flash[:notice] = "That isn't your blog post!"
      redirect_to :controller => "profile", :action => "show"
      return false
    end
  end
  
      
end