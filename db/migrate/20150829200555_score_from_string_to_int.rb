class ScoreFromStringToInt < ActiveRecord::Migration
  def change
    add_column :games, :winner_score, :integer, default: 0
    add_column :games, :loser_score, :integer, default: 0

    Game.find_each do |game|
      if game.score
        scores = game.score.split(' : ').map(&:to_i)
        game.update_attributes!(winner_score: scores[0], loser_score: scores[1])
      end
    end

    remove_column :games, :score
  end
end
