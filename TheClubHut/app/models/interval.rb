class Interval < ActiveRecord::Base
  belongs_to :trainingsession
validates_numericality_of :distance, :message => "can only be whole number.", :greater_than_or_equal_to => 0 if :dist_or_dur == "distance"
  
  def validate
    
    if dist_or_dur == "duration"
      if duration_hr == 0 and duration_min == 0 and duration_sec == 0
        errors.add("Interval must ", "have either a time or a distance.")
      end
    else
      if distance == "" 
        errors.add("Interval must ", "have either a time or a distance.")
      end
    end
  
    
  end
  
end
