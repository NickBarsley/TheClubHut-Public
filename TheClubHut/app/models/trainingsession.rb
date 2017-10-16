class Trainingsession < ActiveRecord::Base

  after_update :save_interval

  has_many :interval, :dependent => :destroy, :order => :position

  def new_interval_attributes=(interval_attributes)
    interval_attributes.each do |attributes|
      interval.build(attributes)
    end
  end
  
  def existing_interval_attributes=(interval_attributes)
    interval.reject(&:new_record?).each do |intervala|
      attributes = interval_attributes[intervala.id.to_s]
      if attributes
        intervala.attributes = attributes
      else
        interval.delete(intervala)
      end
    end
  end
  
  def save_interval
    interval.each do |interval|
      interval.save(false)
    end
  end
  







end
