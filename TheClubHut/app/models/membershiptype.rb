class Membershiptype < ActiveRecord::Base
has_one :forum
has_many :membership, :dependent => :destroy



end
