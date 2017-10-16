class CreateTrainingsessions < ActiveRecord::Migration
  def self.up
    create_table :trainingsessions do |t|
      t.integer :team_id
      t.datetime :scheduled
      t.integer :booking_id
      t.string :teamorind

      t.timestamps
    end
  end

  def self.down
    drop_table :trainingsessions
  end
end
