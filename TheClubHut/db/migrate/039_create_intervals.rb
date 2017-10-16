class CreateIntervals < ActiveRecord::Migration
  def self.up
    create_table :intervals do |t|
      t.integer :trainingsession_id
      t.integer :user_id
      t.integer :order
      t.integer :rest
      t.integer :distance
      t.string :distance_units
      t.integer :duration
      t.string :duration_units
      t.integer :aim_for_rate
      t.integer :aim_for_split_min
      t.integer :aim_for_split_sec
      t.integer :aim_for_split_point
      t.integer :aim_for_wattage
      t.integer :res_rate
      t.integer :res_wattage
      t.integer :res_avg_hr
      t.integer :res_max_hr
      t.integer :res_split_min
      t.integer :res_split_sec
      t.integer :res_split_point
      t.string :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :intervals
  end
end
