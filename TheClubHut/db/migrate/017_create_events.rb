class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|

      t.date :date
      t.string :title
      t.text :description
      t.integer :dataestatus_id
      t.datetime :when_entries_open
      t.datetime :when_entries_close
      
      t.integer :sport_id
      t.integer :club_id
      t.time :start_time
      t.integer :user_id      
      t.string :created_by_owner
      t.integer :dataetype_id
      t.string :venue
      t.integer :datacountry_id
      t.string :locationcode
      t.integer :num_of_categories
      t.string :ind_or_team
      
      t.timestamps
    end
    
    # Create event data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_events.csv"
    fields = '(id, date, title, description, datacountry_id, locationcode, venue, dataestatus_id, sport_id, user_id, created_by_owner, dataetype_id)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE events FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields  
  end

  def self.down
    drop_table :events
  end
end
