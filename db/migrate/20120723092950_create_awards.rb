class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.references :player
      t.references :badge
      t.datetime :award_date
      t.datetime :expiry

      t.timestamps
    end
  end
end
