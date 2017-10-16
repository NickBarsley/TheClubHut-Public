class Race < ActiveRecord::Base
belongs_to :event, :order => "date ASC"
belongs_to :team
belongs_to :user, :order => "surname DESC"
has_many :photos


end
