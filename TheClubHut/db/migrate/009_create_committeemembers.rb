class CreateCommitteemembers < ActiveRecord::Migration
  def self.up
    create_table :committeemembers do |t|
      t.integer :committee_id
      t.integer :user_id
      t.string :position
      t.integer :roworder
      
      t.timestamps
    end
  end

  def self.down
    drop_table :committeemembers
  end
end
