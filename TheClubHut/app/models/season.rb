class Season < ActiveRecord::Base
has_many :team
belongs_to :club

validates_presence_of :description

end
