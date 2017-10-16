class CreateJamies < ActiveRecord::Migration
  def self.up
    create_table :jamies do |t|
      t.string :name
      t.integer :age
      t.integer :favourite
      t.datetime :cerness

      t.timestamps
    end
  end

  def self.down
    drop_table :jamies
  end
end
