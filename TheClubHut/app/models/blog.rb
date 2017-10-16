class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :blogposts, :order => "created_at DESC"

end
