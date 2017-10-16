class Photo < ActiveRecord::Base
belongs_to :race
belongs_to :item

require 'rubygems'
require 'RMagick'
include Magick

has_attachment  :content_type => :image,
                :storage => :file_system,
                :size => 0.megabyte..5.megabytes,
                :resize_to => '640x480>',
                :thumbnails => { :thumb => '160x120', :tiny => '50>' }

validates_as_attachment



end
