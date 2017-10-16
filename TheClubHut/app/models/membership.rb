class Membership < ActiveRecord::Base

  belongs_to :club
  belongs_to :user
  belongs_to :membershiptype
  belongs_to :committee_member
  
  validates_presence_of :user_id, :club_id

  



 # has_many :clubmembers,
 #          :through => :membership,
 #          :conditions => "status = 'accepted'"##

#  has_many :requested_clubmembers,
#           :through => membership,
#           :conditions => "status = 'requested'"
           


  # Record a pending membership request.
  def self.request(user, club)

  end


  # Return true if the user is already a member of the club.
  def self.exists?(user, club)
    not find_by_user_id_and_club_id(user, club).nil?
  end

    
  # Delete a friendship or cancel a pending request.
  def self.breakup(user, club)
    destroy(find_by_user_id_and_club_id(user, club))
  end

  

end
