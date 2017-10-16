class Booking < ActiveRecord::Base

belongs_to :user
belongs_to :club

def renderEvent(current_left, logged_in)
  startofweek = 0
  @html = ""
  
#  theday = 0
#  if start_time.day == startofweek
#    theday = 1
#  elsif start_time.day == startofweek + 1 
#    theday = 2
#  elsif start_time.day == startofweek + 2
#    theday = 3
#  elsif start_time.day == startofweek + 3
#    theday = 4    
#  elsif start_time.day == startofweek + 4
#    theday = 5
#  elsif start_time.day == startofweek + 5
#    theday = 6
#  elsif start_time.day == startofweek + 6
#    theday = 7
#  end



  theday=0
  posLeft = (current_left + (theday - 1) * 85).to_s
  posTop = ((18 + (start_time.hour - 4)*31) + (start_time.min.to_f) * 0.516666).to_s

  # improve by being precise about pixels for each case.
  if duration == 120
    posHeight = 61.to_s
  elsif duration == 60
    posHeight = 30.to_s
  elsif duration == 90
    posHeight = 45.to_s
  elsif duration == 30
    posHeight = 15.to_s  
  else
    posHeight = (duration.to_f * 0.51666666666666666666666666).to_s
  end

  if weights == 1
    posWidth = 10.to_s
    bg = "#c0504d"
    border = "#8c3836"
    thebooking = "Weights room booked for circuits"
  else
    posWidth = ((8*no_ergs) + (no_ergs - 1)).to_s
    if club_id == 1
      bg = "#9bbb59"
      border = "#71893f"
    elsif club_id == 7
      bg = "#8064a2"
      border = "#5c4776"  
    end
    if no_ergs.to_i == 1
      thebooking = no_ergs.to_s + " Erg Booked"
    else
      thebooking = no_ergs.to_s + " Ergs Booked"
    end
  end

  if user.spec
    if user.spec.phone_mobile == nil
      mob = "<i>no mobile number listed</i>"
    else
      mob = user.spec.phone_mobile
    end
  else
    mob = "<i>no mobile number listed</i>"
  end

  
  if start_time.min == 0
    minstart = "00"
  else
    minstart = start_time.min.to_s
  end

    if end_time.min == 0
    minend = "00"
  else
    minend = end_time.min.to_s
  end
  
  email = "<a href=\"mailto:" + user.email.to_s + "\">"  + user.email.to_s + "</a>"
  if club.officialsite == "No"
    clubtext = "<a href=\"" + club.website + "\">"  + club.initials + "</a>"
  else
    clubtext = "<a href=\"clubs/" + club.id.to_s + "\">"  + club.initials + "</a>"
  end
  
  if logged_in
      message = "<div id=\"div" + id.to_s + "\" class=\"bookingDetails\" style=\"top: " + (posTop.to_i + 10).to_s + "px; left: " + (posLeft.to_i + 10).to_s + "px;\"><b>" + thebooking + "</b><BR />By: " + "<a href=\"/profile/show/" + user.id.to_s + "\">" + user.full_name + "</a>" + " (" + clubtext + ")<BR />From: " + start_time.hour.to_s + ":" + minstart + " to " + end_time.hour.to_s + ":" + minend + "<BR/>Mobile: " + mob.to_s + "<BR />Email: " + email.to_s + "</div>"
  else
    message = "<div id=\"div" + id.to_s + "\" class=\"bookingDetails\"><b>" + thebooking + "</b><BR />By: <i>Please log in to view this info. </i><BR />Club: " + clubtext + "<BR />From: " + start_time.hour.to_s + ":" + minstart + " to " + end_time.hour.to_s + ":" + minend + "<BR/>Mobile: <i>Please log in to view this info.</i><BR/>Email: <i>Please log in to view this info.</i></div>"
  end
  
  @html += "<div class=\"calevent\" style=\"position: absolute; z-index: 0; top: " + posTop + "px; left: " + posLeft + "px; height: " + posHeight + "px; width: " + posWidth + "px; background-color: " + bg + "; border-color: " + border + ";\" onMouseOver=\"toggleDiv(\'div" + id.to_s + "\',1)\" onMouseOut=\"toggleDiv(\'div" + id.to_s + "\',0)\">"  + "</div>" + message
  return @html

end


def end_time
  start_time.advance(:minutes => duration)
end

protected

def validate
  # Correct membership properties.
  @member = Membership.find(:all, :conditions => ["user_id=? and status=? and (membershiptype_id=? or membershiptype_id=?)", user_id, "granted", 1, 6])
  if @member.size == 0 and user_id != 6
    errors.add("You must be ", "a Current Member of either QCBC or MBC Erg Booking to use this booking system.") 
  end
  
  # Multiple erg bookings.
  @allbookings = Booking.find(:all, :conditions => ["DATE(start_time) = ?", start_time.year.to_s + "-" + start_time.month.to_s + "-" + start_time.day.to_s ])
  indents = Array.new
  81.times do |i|
    indents << 0
  end
  bookingOK = true
  if @allbookings
    @allbookings.each do |abooking|
      (abooking.duration / 15).times do |i|
        indents[((abooking.start_time.hour-4)*4+(abooking.start_time.min/15)) + i] += abooking.no_ergs
      end
    end
    slotsneeded = duration / 15
    slotsneeded.times do |slot|
      if indents[((start_time.hour-4)*4+(start_time.min/15)+slot)] + no_ergs > 8
        bookingOK = false
      end
    end
  end
  if bookingOK == false
    errors.add("Your booking would put the number of ergs booked to more than ", "the 8 available.")
  end
  
  # The past.
  errors.add("Your booking ", "is in the past.") if start_time < Time.now

  # Weekly priority times.
  currentDay = start_time.strftime("%w")
    
  if currentDay == 0 
    currentDay = 7
  end
  if currentDay.to_i == 1 #Monday split QCBC and MBC
    if start_time.hour >= 17 and start_time.hour < 18 and club_id != 1 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during QCBC's priority slot. However, you may book it 24 hours before the priority slot.")
    end
    if start_time.hour >= 18 and start_time.hour < 19 and club_id != 7 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during MBC's priority slot. However, you may book it 24 hours before the priority slot.")
    end    
  elsif currentDay.to_i == 2 #Tuesday all QCBC
    if start_time.hour >= 17 and start_time.hour < 19 and club_id != 1 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during QCBC's priority slot. However, you may book it 24 hours before the priority slot.")
    end
  elsif currentDay.to_i == 3 #Wednesday all MBC
    if start_time.hour >= 17 and start_time.hour < 19 and club_id != 7 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during MBC's priority slot. However, you may book it 24 hours before the priority slot.")
  end  
  elsif currentDay.to_i == 4 #Thursday
    if start_time.hour >= 17 and start_time.hour < 19 and club_id != 7 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during MBC's priority slot. However, you may book it 24 hours before the priority slot.")
    end    
  elsif currentDay.to_i == 5 #Friday
    if start_time.hour >= 17 and start_time.hour < 19 and club_id != 1 and start_time > Time.now.advance(:hours => 24)
      errors.add("Your booking ", "is during QCBC's priority slot. However, you may book it 24 hours before the priority slot.")
    end
  end
  
  #  if Booking.exists?(["(start_time > ? OR start_time < ?) OR (end_time < ? OR end_time > ?)", booking.start_time, booking.end_time, booking.start_time, booking.end_time ])
#    true
#  else 
#    false
#  end
#  allbookings = Booking.find(:all, :order => "start_time DESC")
#  indents = Array.new(size=81)
#  bookingOK = true
#  if allbookings
#    allbookings.each do |abooking|
#      if abooking.start_time.day == start_time.day   # improve this to deal with months.
#        indents[((abooking.start_time.hour-4)*4+(abooking.start_time.min/15))] += abooking.no_ergs
#      end
#    end
#    2.times do |slot|
#      if indents[((start_time.hour-4)*4+(start_time.min/15)+slot)] + no_ergs > 8
#        bookingOK = false
#      end
#    end
#  end
  

end




end
