class CreateSpecs < ActiveRecord::Migration
  def self.up
    create_table :specs do |t|
      t.column :user_id,    :integer, :null => false
      t.column :gender,     :string, :default => ""
      t.column :birthdate,  :date
      t.column :occupation, :string, :default => ""
      t.column :city,       :string, :default => ""
      t.column :county,      :string, :default => ""
      t.column :country,   :string, :default => ""
      t.column :locationcode,   :string, :default => ""    
      t.column :language,   :integer,  :default => "1"
      t.string :phone_mobile
      t.string :phone_landline
    end      

    add_column :specs, :gender_privacy, :integer, :default => 7
    add_column :specs, :birthdate_privacy, :integer, :default => 7
    add_column :specs, :occupation_privacy, :integer, :default => 7
    add_column :specs, :city_privacy, :integer, :default => 15
    add_column :specs, :county_privacy, :integer, :default => 15
    add_column :specs, :country_privacy, :integer, :default => 15
    add_column :specs, :locationcode_privacy, :integer, :default => 7
    add_column :specs, :language_privacy, :integer, :default => 15
    add_column :specs, :phone_mobile_privacy, :integer, :default => 7
    add_column :specs, :phone_landline_privacy, :integer, :default => 7

    add_column :specs, :height_cm, :integer
    add_column :specs, :height_unit, :integer
    add_column :specs, :height_privacy, :integer, :default => 15
    
    add_column :specs, :armspan_cm, :integer
    add_column :specs, :armspan_unit, :integer
    add_column :specs, :armspan_privacy, :integer, :default => 7
    
    add_column :specs, :insideleg_cm, :integer
    add_column :specs, :insideleg_unit, :integer
    add_column :specs, :insideleg_privacy, :integer, :default => 7
      
    add_column :specs, :shoesize, :integer
    add_column :specs, :shoesize_unit, :integer
    add_column :specs, :shoesize_privacy, :integer, :default => 7
    
    add_column :specs, :address_line1, :string
    add_column :specs, :address_line2, :string
    add_column :specs, :address_line3, :string
    add_column :specs, :address_line_privacy, :integer, :default => 7
    
    add_column :specs, :university, :integer
    add_column :specs, :university_privacy, :integer, :default => 15
    
    add_column :specs, :matriculation_year, :integer
    add_column :specs, :matriculation_year_privacy, :integer, :default => 15
    
    add_column :specs, :course, :integer
    add_column :specs, :course_privacy, :integer, :default => 15
    
    add_column :specs, :rower_type, :integer
    add_column :specs, :rower_type_privacy, :integer, :default => 15
      
    add_column :specs, :aboutme, :text      
      

  end

  def self.down
    drop_table :specs
  end
end
