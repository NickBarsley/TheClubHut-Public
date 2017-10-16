class CoachController < ApplicationController
  
  before_filter :protect
  
  def index
  @title = "Coaching Feedback"
    
  end
  
  
  def feedback
    if params[:id]
      # Check that the current user is a coach of this person.
      
      
      # They are, does a forum exist?
      @user = User.find_by_id(params[:id].to_i)
      data = {    "name" => @user.firstname + "'s Coaching Feedback", 
                  "description" => "This forum contains feedback from your coaches. Only you and your club coaches can see the posts in this forum.",
                  "topics_count" => 0,
                  "posts_count" => 0,
                  "position" => 1,
                  "description_html" => "<p>This forum contains feedback from your coaches. Only you and your club coaches can see the posts in this forum.</p>",
                  "user_id" => session[:user_id].to_i }
      @forum = @user.forum ||= Forum.new(data)
      @forum.save
      
    
      thepath = forum_path(@forum)  
    else
      thepath = "/coach/"
    end
    redirect_to thepath
    
  end
  
end
