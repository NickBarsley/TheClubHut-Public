class Item < ActiveRecord::Base
has_many :review, :dependent => :destroy
has_many :photo

def review_attributes=(review_attributes)
  review.build(review_attributes)
end

def photo_attributes=(photo_attributes)
  photo.build(photo_attributes)
end

end
