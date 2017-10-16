class WorksController < ApplicationController

def advance
  session[:booking_viewingweek] = session[:booking_viewingweek] + 1.week
  redirect_to(bookings_url)
end

def retreat
  session[:booking_viewingweek] = session[:booking_viewingweek] - 1.week
  redirect_to(bookings_url)
end

def clubjoin
  session[:club_id] = params[:id]
  redirect_to(new_club_membership_path(session[:club_id]))
end

def misctask
  if session[:user_id].to_i == 6
  
    
  
    
  end
  
end


end
