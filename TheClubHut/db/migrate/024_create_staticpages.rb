class CreateStaticpages < ActiveRecord::Migration
  def self.up
    create_table :staticpages do |t|
      t.integer :club_id
      t.string :toolbar_title
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :staticpages
  end
end
