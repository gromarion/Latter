class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :challenger, null: false
      t.references :challenged, null: false
      t.boolean :complete, null: false, default: false
      t.float :result
      t.integer :winner_score
      t.integer :loser_score

      t.decimal :challenger_rating_change
      t.decimal :challenged_rating_change
      t.references :winner

      t.timestamps
    end

    add_index :games, :challenger_id
    add_index :games, :challenged_id
    add_index :games, [:challenger_id, :challenged_id]
    add_index :games, :complete
  end
end
