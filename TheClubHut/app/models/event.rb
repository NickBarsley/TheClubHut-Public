class Event < ActiveRecord::Base
has_many :race, :dependent => :destroy
has_one :country
belongs_to :club

end
