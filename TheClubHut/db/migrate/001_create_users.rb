class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :firstname, :string
      t.column :surname, :string
      t.column :screen_name, :string
			t.column :email, :string 
			t.column :password, :string 
      t.column :created_at, :timestamp 
      t.column :updated_at, :timestamp       
      t.column :authorization_token, :string
    end
  end

  def self.down
    drop_table :users
  end
end