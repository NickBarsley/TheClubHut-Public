class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :race_id
      t.string :title
      t.text :body
      
      # the following are required for attachment_fu
      t.column :content_type, :string, :limit => 100
      t.column :filename, :string, :limit => 25
      t.column :path, :string, :limit => 255
      t.column :parent_id, :integer
      t.column :thumbnail, :string, :limit => 255
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      


      
       t.timestamps
   end
   
   add_column :teams, :photos_count, :integer
  end

  def self.down
    drop_table :photos
    remove_column :teams, :photos_count
  end
end
