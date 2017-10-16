class EmailController < ApplicationController
helper :avatar, :clubavatar
before_filter :protect, :only => [:invite, :clubemail]

def remind
  @title = "Reset Password"
    
  if param_posted?(:user)
    email = params[:user][:email]
    user  = User.find_by_email(email)
    if user
      newpass = random_pronouncable_password
      user.password = MD5.new(newpass).to_s
      user.password_reset = 1
      user.save
      UserMailer.deliver_reminder(user, newpass)
      flash[:notice] = "Login information was sent."
      redirect_to :action => "index", :controller => "site"
    else
      flash[:notice] = "There is no user with that email address."
    end
  end
end

def invite
  @title = "Invite a member to your club website"
  if session[:club_id] != nil
    if param_posted?(:user)
      tempstore = params[:user][:membershiptype_id].to_i
      params[:user].delete(:membershiptype_id)
      @user = User.new(params[:user])
      
      newpass = random_pronouncable_password(3)
      @user.password = MD5.new(newpass).to_s
      @user.password_reset = 1
      @inviter = User.find_by_id(session[:user_id])
      @club = Club.find(session[:club_id])
      if @user.save 
        @membership = Membership.new
        @membership.user_id = @user.id
        @membership.club_id = session[:club_id]
        @membership.membershiptype_id = tempstore
        @membership.status = "invited"
        @membership.save
        UserMailer.deliver_invitation(@user, newpass, @club.name, @inviter.full_name)
        flash[:notice] = "#{@user.firstname} has been invited to " + @club.name + "."
        redirect_to admin_club_path(session[:club_id])
      else
        @user.clear_password!
      end
    else
      @user=User.new
    end
  else
    flash[:notice] = "You must be logged on as a committee member of a club to be able to invite a member."
    redirect_to :action => "index", :controller => "clubs"
  end
end


def clubemail
  if session[:club_id] != nil
    @club = Club.find(session[:club_id])
    @title = "Email " + @club.initials
    @sender = User.find(session[:user_id])
    if param_posted?(:email)
      if params[:email][:membershiptype_ids].nil?
        flash[:notice] = "You must select a membership group to email!"
        thepath = "/email/clubemail"
      else
        recipients = Array.new
        params[:email][:membershiptype_ids].each do |type|
          # Find the membership type, and create you. 
          @membershiptype = Membershiptype.find_by_id(type)  
          data = {  "name" => @membershiptype.name_plural, 
                    "description" => "This forum is for the " + @membershiptype.description + " only.",
                    "topics_count" => 0,
                    "posts_count" => 0,
                    "position" => 0,
                    "description_html" => "<p>" + "This forum is for the " + @membershiptype.description + " only.</p>",
                    "club_id" => @membershiptype.club_id,
                    "membershiptype_id" => @membershiptype.id }
          @membershiptypeforum = @membershiptype.forum ||= Forum.new(data)
          @membershiptypeforum.save
      
          @user = User.find_by_id(session[:user_id])
          @topic = Topic.find(:all, :conditions => ["title=? and forum_id=?", "Email Records", @membershiptypeforum.id])
          if @topic.size == 0
            # The "Email Record" topic doesn't exist.
            data = {  "title"=>"Email Records",
                      "body"=>"These are the emails sent through sipbib.com.",
                      "user_id" => session[:user_id],
                      "forum_id" => @membershiptypeforum.id }
            Topic.transaction do
        	    @topic  = @membershiptypeforum.topics.build(data)
              @post       = @topic.posts.build(data)
              @post.topic = @topic
              @post.user  = @user
              @topic.user = @user
            end
            @topic.locked = 1
            @topic.save!
          else
            @topic = Topic.find(:first, :conditions => ["title=? and forum_id=?", "Email Record", @membershiptypeforum.id])
          end        
          data = {  "body" => "Subject: " + params[:email][:emailsubject] + "<BR/><BR/>Body: " + params[:email][:emailbody] }
          @post  = @topic.posts.build(data)
          @post.user = @user
          @post.save!
          
          
          # Find the people who hold the membership, and add them to an array called recipients.
          @members = Membership.find(:all, :conditions => ["membershiptype_id=? and status=?", type, "granted"])
          @members.each do |member|
            recipients << member.user_id
          end      
        end
        recipients.uniq!
        recipients.size.times do |i|
          @user = User.find_by_id(recipients[i])
          UserMailer.deliver_clubemail(@user, @club, @sender, params[:email][:emailbody], params[:email][:emailsubject])          
        end      
        
        flash[:notice] = "Your email has been successfully sent to " + recipients.size.to_s + " recipients."
        thepath = admin_club_path(session[:club_id])
      end

      redirect_to thepath
    else
      @email
    end
  end
end

def teamemail
  if param_posted?(:teamemail)
    @sender =  User.find(session[:user_id])
    @team = Team.find(params[:teamemail][:team_id])
    if params[:teamemail][:user_ids].nil?
      flash[:notice] = "You must select at least one team member to email!"
      thepath = teamemail_team_path(params[:teamemail][:team_id])
    else
      numrecipients = params[:teamemail][:user_ids].size
      params[:teamemail][:user_ids].each do |type|
        @user = User.find_by_id(type)
        UserMailer.deliver_teamemail(@user, @sender, @team, params[:teamemail][:emailbody], params[:teamemail][:emailsubject], numrecipients)
      end
      flash[:notice] = "Your email has been successfully sent to " + numrecipients.to_s + " recipients."
      thepath = team_path(params[:teamemail][:team_id])
    end
    redirect_to thepath
  end
end


private

def random_password(size = 8)
  chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
  (1..size).collect{|a| chars[rand(chars.size)] }.join
end

def random_pronouncable_password(size = 4)
  c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
  v = %w(a e i o u y)
  f, r = true, ''
  
  (size * 2).times do
    r << (f ? c[rand * c.size] : v[rand * v.size])
    f = !f
  end
  return r
end




end
