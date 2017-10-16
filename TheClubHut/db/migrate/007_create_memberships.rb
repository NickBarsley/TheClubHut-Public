class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :club_id
      t.string :status
      t.date :starting_from
      t.date :ending_on
      t.datetime :accepted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
