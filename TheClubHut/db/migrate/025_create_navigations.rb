class CreateNavigations < ActiveRecord::Migration
  def self.up
    create_table :navigations do |t|
      t.integer :club_id
      t.integer :indexorder
      t.string :indexlinkname
      t.integer :staticpage_id
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :navigations
  end
end
