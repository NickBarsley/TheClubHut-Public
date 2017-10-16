class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :club_id
      t.string :description
      t.datetime :starts_from
      t.datetime :ends_on
      t.timestamps
    end

    # Create season data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_seasons.csv"
    fields = '(id, club_id, description, starts_from, ends_on)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE seasons FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields   
  
  end

  def self.down
    drop_table :seasons
  end
end
