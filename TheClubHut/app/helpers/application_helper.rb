require 'md5'
require 'cgi'

module ApplicationHelper 

  # Return a link for use in layout navigation. 
  def nav_link(text, controller, action="index", id=nil) 
    link_to_unless_current text, :controller => controller, 
                                        :action => action,
                                        :id => id
  end 

  def monthname(monthnumber)
    if monthnumber
      Date::MONTHNAMES[monthnumber][0,3]
    end
  end



  def allowed_to_view_forum(forum, user_id)
    permissionproblem = false
    # Is this a personal coaching feedback forum? If so is it theirs?
    if forum.user_id != nil and forum.user_id != user_id
      # Find all the teams that this person is a coach of.  
      @teams = Team.find(:all, :conditions => ["user_id=? and position=?", user_id, 0], :include => :teammember)
      people_userid_can_see = Array.new
      @teams.each do |team|
        @team = Team.find_by_id(team.id)
        @team.teammember.each do |member|
          if member.user.id != user_id.to_i
            people_userid_can_see << member.user.id
          end
        end
      end
      
      @coachingclubmemberships = Membership.find(:all, :conditions => ["user_id=? and clubcoach=?", user_id, 1], :include => :membershiptype ) 
      if @coachingclubmemberships.size != 0 
      @coachingclubmemberships.each do |membership| 
        @coachablemembershiptypes = Membershiptype.find(:all, :conditions => ["club_id=? and coachable=?", membership.club_id, 1]) 
          if @coachablemembershiptypes.size != 0 
            @coachablemembershiptypes.each do |coachablemembershiptype| 
              @coachablemembers = Membership.find(:all, :conditions => ["membershiptype_id=?", coachablemembershiptype.id], :order => "surname ASC", :include => :user)   
                if @coachablemembers.size != 0 
                  @coachablemembers.each do |member| 
                    if member.user.id != user_id.to_i
                      people_userid_can_see << member.user.id
                    end
                  end 
                end 
            end 
          end 
        end
      end  

      @teams = Team.find(:all, :conditions => ["user_id=?", user_id], :include => :teammember)
      if @teams.size != 0
        @teams.each do |team|
          @team = Team.find_by_id(team.id)
          @team.teammember.each do |member|
            if member.position == "0"
              people_userid_can_see << member.user.id
            end
          end
        end
      end
       
      @coachingclubmemberships = Membership.find(:all, :conditions => ["user_id=? and coachable=?", user_id, 1], :include => :membershiptype )
      if @coachingclubmemberships.size != 0
        @coachingclubmemberships.each do |membership| 
          @coachablemembershiptypes = Membershiptype.find(:all, :conditions => ["club_id=? and clubcoach=?", membership.club_id, 1]) 
            if @coachablemembershiptypes.size != 0 
              @coachablemembershiptypes.each do |coachablemembershiptype| 
                @coachablemembers = Membership.find(:all, :conditions => ["membershiptype_id=?", coachablemembershiptype.id], :order => "surname ASC", :include => :user)
                  if @coachablemembers.size != 0 
                    @coachablemembers.each do |member| 
                      if member.user.id != user_id
                        people_userid_can_see << member.user.id
                      end
                    end
                  end
              end
            end
          end
        end

      people_userid_can_see.uniq!
      if people_userid_can_see.include?(forum.user_id)

      else
        permissionproblem = true
      end
      
    end
  
    # Is this a personal coaching feedback forum? If so is it theirs?
    if forum.priveleged == 1 and !current_club_committee(forum.club_id)
        permissionproblem = true
    end
    
    # Is this a team forum?
    if forum.team_id != nil 
      if !current_team(forum.team_id)
      permissionproblem = true
      end
    end
    
    
    # Is this a club membership type forum? If so is it theirs?
    if forum.membershiptype_id != nil 
      @membership = Membership.find(:all, :conditions => ["user_id=? AND membershiptype_id=? AND club_id=? AND status=?", session[:user_id].to_i, forum.membershiptype_id, forum.club_id, "granted"])
      if @membership.size == 1
        # Record found! 
      else
        @membershiptype = Membershiptype.find_by_id(forum.membershiptype_id)
        permissionproblem = true
      end
    end
    
    # Is this a club membership type forum? If so is it theirs?
    if forum.allmembershiptypes == 1 
      @membership = Membership.find(:all, :conditions => ["user_id=? AND club_id=? AND status=?", user_id, forum.club_id, "granted"])
      if @membership.size >= 1
        # Record found! 
      else
        @club = Club.find_by_id(forum.club_id)
        permissionproblem = true
      end
    end
    
    if session[:user_id] != nil
      if session[:user_id].to_i == 6
        permissionproblem = false
      end
    end
    
    return permissionproblem
  end

def returntimer(date)
  if date.min == 0
    minstart = "00"
  else
    minstart = date.min.to_s
  end  
  stringer = date.hour.to_s + ":" + minstart
  return stringer
end

  def number_to_ordinal(num)
    num = num.to_i
    if (10...20)===num
    "#{num}<sup>th</sup>"
    else
    g = %w{ <sup>th</sup> <sup>st</sup> <sup>nd</sup> <sup>rd</sup> <sup>th</sup> <sup>th</sup> <sup>th</sup> <sup>th</sup> <sup>th</sup> <sup>th</sup> }
    a = num.to_s
    c=a[-1..-1].to_i
    a + g[c]
    end
  end

def returndatestring(date)
  return number_to_ordinal(date.day).to_s + " " + monthname(date.month) + " " + date.year.to_s
end

  def numofraces(user_id)
    @teammembers = Teammember.find(:all, :conditions => ["user_id=?", user_id])
    @allraces = Array.new
    @teammembers.each do |teammember|
      @races=Race.find(:all, :conditions=>["team_id=?", teammember.team_id])
        @races.each do |race|
          @allraces << race
          end
    end
    return @allraces.size
  end

def privacy(decimal)
  binary = decimal.to_s(2)
  while binary.length < 5
    binary = "0" + binary
  end
  return binary
end



  # Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil?
  end

  # Return true if currently browsing a club page?
  def club_page?
    not session[:club_id].nil?
  end

  def profile_viewed_matches_login?(viewed, loggedin)
    if viewed.to_i == loggedin.to_i
      session[:profile_viewed_matches_login] = true
      return true
    else
      session[:profile_viewed_matches_login] = false   
      return false
    end
  end

def committee_position(year, user_id)
  # Give back a string saying what committees the person belonged to through the year. 
  @output = nil
 
  @committeemembers = Committeemember.find(:all, :conditions => [ "user_id=?", user_id])
  if @committeemembers.size != 0
    @committeemembers.each do |committeeposition|
      @committee = Committee.find(:first, :conditions => ["id=?", committeeposition.committee_id])
      if @committee
      if @committee.in_office_from.year == year
        @output = " > " + @committee.club.initials + " > " + committeeposition.position
      end
    end
    end
  else
  @output == ""
  end
  return @output
  
end

  def current_club_committee?
    # Current club id gives which club we're talking about.
    if session[:club_id]
      session[:current_club_committee] = false
      if @currentcommittee = Committee.find(:first, :conditions => [ "club_id=?", session[:club_id].to_i], :order => "in_office_from DESC")
        if @committeemembers = Committeemember.find(:all, :conditions => [ "committee_id=?", @currentcommittee.id])
          unless @committeemembers.empty?
            @committeemembers.each do |committeemember|
              if committeemember.user.id == session[:user_id].to_i or session[:user_id] == 6 # Super User for Nick - Committee member of all clubs.
               session[:current_club_committee] = true
              else
              end
          end
          end
                    
        else
#        flash[:notice]="This club has no committee members."
        end
      else
#        flash[:notice]="This club has no committese listed."      
      end
    else
    end

    if session[:current_club_committee] == true
      return true
    else
      return false
    end
  
  end

  def current_club_committee(club_id)
    # Current club id gives which club we're talking about.
      session[:current_club_committee] = false
      if @currentcommittee = Committee.find(:first, :conditions => [ "club_id=?", club_id], :order => "in_office_from DESC")
        if @committeemembers = Committeemember.find(:all, :conditions => [ "committee_id=?", @currentcommittee.id])
          if @committeemembers.empty?
#            if session[:user_id].to_i == 6
#              session[:current_club_committee] = true
#            end
          else
            @committeemembers.each do |committeemember|
              if committeemember.user_id == session[:user_id].to_i #or session[:user_id].to_i == 6 # Super User for Nick - Committee member of all clubs.
               session[:current_club_committee] = true
              else
              end
          end
          end
                    
        else
#        flash[:notice]="This club has no committee members."
        end
      else
#        flash[:notice]="This club has no committese listed."      
      end

    if session[:current_club_committee] == true
      return true
    else
      return false
    end
  
  end


  def committee_of_clubs(user_id)
    # Takes in a user_id and finds which current committees they are on. Returns an array which each of club_id's they are in.
    
      array_committee_of_clubs = Array.new
#      @clubs = Club.find(:all)
#      @clubs.each do |club|
#          if @currentcommittee = Committee.find(:first, :conditions => [ "club_id=?", club], :order => "in_office_from DESC")
#            if @committeemembers = Committeemember.find(:all, :conditions => [ "committee_id = #{@currentcommittee.id}"], :order => "roworder DESC")
#              unless @committeemembers.empty?
#                @committeemembers.each do |committeemember|
#                  if session[:user_id] == 6 # Super User for Nick - Committee member of all clubs.
#                   array_committee_of_clubs << club
#                  end
#                end
#              end
#            end
#          end
#        end

  @clubs = Club.find(:all)
  @clubs.each do |club|
    if current_club_committee(club.id.to_i)
      array_committee_of_clubs << club
    end
  end
  return array_committee_of_clubs.uniq!
    
  end
    

    

def current_team(team_id)
  increw = false
  if session[:user_id]
    @team = Team.find(team_id)
    @team.teammember.each do |teammember|
      if teammember.user_id == session[:user_id].to_i
        increw = true
      end
    end
  end
  return increw    
  
end
  

  def text_field_for(form, field, 
                   size=HTML_TEXT_FIELD_SIZE, 
                   maxlength=DB_STRING_MAX_LENGTH)
    label = content_tag("label", "#{field.humanize}:", :for => field)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "form_row")
  end
  
  def paginated?
    @pages and @pages.length > 1
  end
  
  def fullname(firstname, surname)
    @fullname = (firstname.strip + " " + surname.strip)
  end

  def shortername(firstname, surname)
    @shortername = firstname[0,1] + ". " + surname
  end
  
  def background
    if session[:club_id] != nil 
      @club = Club.find(session[:club_id])
      @backgroundcolor = @club.backgroundcolor
    else
      @backgroundcolor = "#" + rand(9).to_s + rand(9).to_s + rand(9).to_s
        # good function - but could be white!
        #      validChars = ("A".."F").to_a + ("0".."9").to_a
        #      length = validChars.size
        #      @backgroundcolor = "#"
        #      1.upto(6) { |i| @backgroundcolor << validChars[rand(length-1)] }
    end
    
    if session[:club_id] == 8
    	@backgroundcolor = "#" + rand(9).to_s + rand(9).to_s + rand(9).to_s
  	end
  	
  end
  
  def printstars(num)
    @string = image_tag("/images/" + num.to_s + "star.gif")
    return @string
  end
  
  def renderClubUnofficialNotice
    # Render the this is an unofficial club notice.
    @club = Club.find(session[:club_id])
    if @club.officialsite == "No"
      @html = "<div class=\"notice\">This is NOT the official website of " + @club.initials + "."
      if @club.website != nil
        @html = @html + "<BR />Click <a href=\"" + @club.website + "\">" + @club.website + "</a> to visit their official website."
      end
      @html += "</div>"
      return @html.to_s
    else
      return nil
    end
  end


end 

