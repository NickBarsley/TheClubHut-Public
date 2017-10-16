class Club < ActiveRecord::Base

  belongs_to :data_sports  
  has_many :membership
  has_many :event
  has_many :committee
  has_many :team
  has_many :navigation
  has_many :season
  has_many :booking
  has_one :blog
  
  def clubavatar
    Clubavatar.new(self)
  end
  
  #acts_as_ferret

  ALL_FIELDS = %w(name initials sport_id locationcode)
  STRING_FIELDS = %w(name initials)

  validates_length_of STRING_FIELDS, 
                      :maximum => DB_STRING_MAX_LENGTH
  validates_uniqueness_of STRING_FIELDS
  validates_uniqueness_of :initials
  validates_presence_of ALL_FIELDS

def navigation_attributes=(navigation_attributes)
  navigation.build(navigation_attributes)
end

end
