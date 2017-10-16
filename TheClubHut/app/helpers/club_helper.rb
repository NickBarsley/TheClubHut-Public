module ClubHelper

  #Return the club's profile URL
  def link_for_club(club)
    club_url(:id => club.id)
  end

end
