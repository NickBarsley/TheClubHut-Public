class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :sport_id
      t.datetime :date
      t.integer :rating_overall
      t.integer :rating_value
      t.date :used_product_since
      t.float :price_paid
      t.string :bought_where
      t.text :summary
      t.text :strengths
      t.text :weaknesses
      t.integer :similar_products

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
