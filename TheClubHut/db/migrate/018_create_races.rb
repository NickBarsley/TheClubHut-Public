class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.integer :event_id
      t.integer :team_id
      t.integer :user_id
      t.string :entry_or_result
      t.string :result
      t.integer :position
      t.integer :gallery_id
      t.text :report
      t.timestamps
    end
  end



  def self.down
    drop_table :races
  end
end
