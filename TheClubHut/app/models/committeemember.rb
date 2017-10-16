class Committeemember < ActiveRecord::Base
belongs_to :committee
belongs_to :user
has_many :membership

end
