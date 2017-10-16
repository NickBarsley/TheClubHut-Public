class SpecController < ApplicationController
  before_filter :protect

  def index
    redirect_to :controller => "profile", :action => "show"
  end

  # Edit the user's spec.
  def edit
    @title = "sipbib: edit profile"
    @user = User.find(session[:user_id])
    @user.spec ||= Spec.new
    @spec = @user.spec
    
    if param_posted?(:spec)
      if @user.spec.update_attributes(params[:spec])
        flash[:notice] = "Changes saved."
        redirect_to :controller => "user", :action => "index"
      end
    end
  end

  # Find by age, sex, location.
  def self.find_by_asl(params)
    where = []
    # Set up the age restrictions as birthdate range limits in SQL.
    unless params[:min_age].blank?
      where << "ADDDATE(birthdate, INTERVAL :min_age YEAR) < CURDATE()"
    end
    unless params[:max_age].blank?
      where << "ADDDATE(birthdate, INTERVAL :max_age+1 YEAR) > CURDATE()"
    end  
    # Set up the gender restriction in SQL.
    where << "gender = :gender" unless params[:gender].blank?
    
    if where.empty?
      []
    else
      find(:all,
           :conditions => [where.join(" AND "), params],
           :order => "last_name, first_name")
    end 
  end
  
  private

  # Return SQL for the distance between a spec's location and the given point.
  # See http://en.wikipedia.org/wiki/Haversine_formula for more on the formula.
  def self.sql_distance_away(point)
    h = "POWER(SIN((RADIANS(latitude - #{point.latitude}))/2.0),2) + " +
        "COS(RADIANS(#{point.latitude})) * COS(RADIANS(latitude)) * " + 
        "POWER(SIN((RADIANS(longitude - #{point.longitude}))/2.0),2)" 
    r = 3956 # Earth's radius in miles
    "2 * #{r} * ASIN(SQRT(#{h}))"
  end


end
