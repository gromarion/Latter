#!bin/rails r

puts 'Migrating String Score to Integer winner_score and loser_score...'

Game.find_each do |game|
  if game.score
    scores = game.score.split(' : ').map(&:to_i)
    game.update_attributes!(winner_score: scores[0], loser_score: scores[1])
  end
end

puts 'DONE!'
