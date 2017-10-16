class CreateCommittees < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.integer :club_id
      t.datetime :elected_on
      t.datetime :in_office_from
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :committees
  end
end
