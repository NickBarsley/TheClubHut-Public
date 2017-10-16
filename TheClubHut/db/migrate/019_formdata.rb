class Formdata < ActiveRecord::Migration
  def self.up
    create_table :datacountrys do |t|
      t.string :name
    end
    # Create event data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_countrys.csv"
    fields = '(id, name)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE datacountrys FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields      

    create_table :dataetypes do |t|
      t.string :description
      t.integer :roworder
    end
    # Create event data for QCBC
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_etypes.csv"
    fields = '(id, description, roworder)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE dataetypes FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields          

  end

  def self.down
    drop_table :datacountrys
    drop_table :dataetypes
  end
end
