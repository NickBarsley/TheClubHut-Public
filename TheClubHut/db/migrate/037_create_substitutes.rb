class CreateSubstitutes < ActiveRecord::Migration
  def self.up
    create_table :substitutes do |t|
      t.integer :teammember_id
      t.integer :race_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :substitutes
  end
end
