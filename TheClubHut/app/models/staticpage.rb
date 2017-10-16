class Staticpage < ActiveRecord::Base

has_one :navigation, :dependent => :destroy

def navigation_attributes=(navigation_attributes)
  build_navigation(navigation_attributes)
end

end

