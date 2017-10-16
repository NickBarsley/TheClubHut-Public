class CreateQcbc < ActiveRecord::Migration
  def self.up
    # Create Club QCBC and Boars Head
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_clubs.csv"
    fields = '(id, name, initials, sport_id, locationcode)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE clubs FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
            
    # Create Committees for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_committees.csv"
    fields = '(id, club_id, elected_on, in_office_from, description, created_at, updated_at)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE committees FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields

    # Create Committee Members for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_committeemembers.csv"
    fields = '(committee_id, user_id, position, roworder, created_at, updated_at)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE committeemembers FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields            

    # Create Committee Members for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_club_memberships.csv"
    fields = '(user_id, club_id, status, created_at, accepted_at, updated_at)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE memberships FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields                        
            
  end

  def self.down
    
  end
end
