class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.integer :required_rating
      t.integer :expire_in_days, default: 0
      t.boolean :allow_duplicates, default: false
      t.timestamps
    end
  end
end
