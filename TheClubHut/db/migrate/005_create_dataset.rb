class CreateDataset < ActiveRecord::Migration
  def self.up
    
    # QCBC Users Data Set
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_QCBC_Users.csv"
    fields = '(id, email, password, firstname, surname)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE users FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
    
    # Sports Data Set
    create_table :data_sports do |t|
      t.column :name, :string
    end  
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_Sports.csv"
    fields = '(name)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE data_sports FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
            
    # USA geo data set.        
    create_table :data_us_geos do |t|
      t.column :locationcode,  :string
      t.column :latitude,  :float
      t.column :longitude, :float
      t.column :city,      :string
      t.column :state,     :string
      t.column :county,    :string
      t.column :type,      :string
    end
    add_index "data_us_geos", ["locationcode"], :name => "locationcode_optimization"
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_US_geo.csv"
    fields = '(locationcode, latitude, longitude, city, state, county)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE data_us_geos FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
            
    # UK geo data set
    create_table :data_uk_geo do |t|
      t.column :locationcode,  :string
      t.column :x,         :integer
      t.column :y,         :integer
      t.column :latitude,  :float
      t.column :longitude, :float
    end
    add_index "data_uk_geo", ["locationcode"], :name => "locationcode_optimization"
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_UK_geo.csv"
    fields = '(locationcode, x, y, latitude, longitude)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE data_uk_geo FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields

    # UK tow geo data set.   
    create_table :data_uk_towns do |t|
      t.column :locationcode,  :string
      t.column :district,  :string
      t.column :x,         :integer
      t.column :y,         :integer
      t.column :latitude,  :float
      t.column :longitude, :float
    end
    csv_file = "#{RAILS_ROOT}/db/migrate/Data_UK_towns.csv"
    fields = '(locationcode, district, x, y, latitude, longitude)'
    execute "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE data_uk_towns FIELDS " +
            "TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields  



            
  end

  def self.down
    drop_table :data_sports
    drop_table :data_us_geos
    drop_table :data_uk_geo
    drop_table :data_uk_towns    
  end
end
