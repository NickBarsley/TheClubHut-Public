class Team < ActiveRecord::Base
  after_update :save_teammember

  validates_presence_of :description, :message => "of team name can't be blank."
  belongs_to :season
  belongs_to :club
  has_many :teammember, :dependent => :destroy, :order => "position DESC"
  has_many :race, :dependent => :destroy
  has_many :photos

  def new_teammember_attributes=(teammember_attributes)
    teammember_attributes.each do |attributes|
      teammember.build(attributes)
    end
  end
  
  def existing_teammember_attributes=(teammember_attributes)
    teammember.reject(&:new_record?).each do |teammembera|
      attributes = teammember_attributes[teammembera.id.to_s]
      if attributes
        teammembera.attributes = attributes
      else
        teammember.delete(teammembera)
      end
    end
  end
  
  def save_teammember
    teammember.each do |teammember|
      teammember.save(false)
    end
  end
  
end
