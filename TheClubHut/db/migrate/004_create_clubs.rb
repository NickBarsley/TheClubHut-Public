class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :name
      t.string :initials
      t.integer :sport_id
      t.string :locationcode
      t.string :backgroundcolor
      
      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
