class DeviseCreatePlayers < ActiveRecord::Migration
  def change
    create_table(:players) do |t|
      t.string :email, null: false, default: ''

      t.string :name, null: false
      t.integer :rating, null: false, default: Elo.config.default_rating
      t.boolean :pro, null: false, default: false
      t.boolean :starter, null: false, default: true

      t.string :image_url
      t.boolean :active, default: true, null: false
      t.string :provider
      t.string :uid

      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :players, :email,                unique: true
    add_index :players, :active
  end
end
