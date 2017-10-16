class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :club_id
      t.integer :season_id
      t.string :description
      t.integer :roworder
      
      t.timestamps
    end
    
    # Create team data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_teams.csv"
    fields = '(id, club_id, season_id, description, roworder, created_at, updated_at)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE teams FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields     
    
  end

  def self.down
    drop_table :teams
  end
end
