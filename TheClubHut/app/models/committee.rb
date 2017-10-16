class Committee < ActiveRecord::Base
  validates_presence_of :club_id
  belongs_to :club
  has_many :committeemember, :dependent => :destroy, :order => "roworder DESC"

def member_attributes=(member_attributes)
  committeemember.build(member_attributes)
end

end
