class UpdateBagdeAttributes < ActiveRecord::Migration
  def change
  	remove_column :badges, :award_rule
  	rename_column :badges, :award_rule_count, :required_ranking
  end
end
