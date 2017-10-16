class CreateTeammembers < ActiveRecord::Migration
  def self.up
    create_table :teammembers do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :sport_id
      t.string :position
      t.integer :roworder

      t.timestamps
      
    end
    
    # Create team data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_teammembers.csv"
    fields = '(id, team_id, user_id, position, roworder, sport_id)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE teammembers FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields   
            
  end

  def self.down
    drop_table :teammembers
  end
end
