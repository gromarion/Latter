class RenameRequiredRankingToRequiredRating < ActiveRecord::Migration
  def change
  	rename_column :badges, :required_ranking, :required_rating
  end
end
