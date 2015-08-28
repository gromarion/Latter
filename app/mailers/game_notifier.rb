class GameNotifier
  def self.notify_challenged(game)
    client = HipChat::Client.new("Wn2YmsDS5mPgnljLdst2u5zAGhhuMTKTJVQARn4J", api_version: 'v2')
    client.user(game.challenged.email).send(
      "PingPously: You have been challenged by #{game.challenger.name} (pingpong)"
    )
    room = client['Ping Pong']
    challenged_mention = fetch_hipchat_mention(game.challenged, room)
    challenger_mention = fetch_hipchat_mention(game.challenger, room)
    if challenged_mention && challenger_mention
      send_to_room(room, "@#{challenged_mention} has challenged @#{challenger_mention} to play (pingpong)!")
    end
  end

  def self.notify_completed_game(game)
    client = HipChat::Client.new("Wn2YmsDS5mPgnljLdst2u5zAGhhuMTKTJVQARn4J", api_version: 'v2')

    winner = Player.find(game.winner_id)
    loser = fetch_looser(game)
    room = client['Ping Pong']
    winner_mention = fetch_hipchat_mention(winner, room)
    loser_mention = fetch_hipchat_mention(loser, room)
    defeated = fetch_defeated_word(game.score)
    if winner_mention && loser_mention
      send_to_room(
        client['Ping Pong'],
        "@#{winner_mention} #{defeated} @#{loser_mention} #{game.score}"
      )
    end
    client.user(loser.email).send("PingPously: You have been #{defeated} by #{winner.name} #{game.score}")
    client.user(winner.email).send("PingPously: You have #{defeated} #{loser.name} #{game.score}")
  end

  private

  def self.fetch_hipchat_mention(player, room)
    player_name = I18n.transliterate(player.name)
    room.get_room()['participants'].each do |participant|
      return participant['mention_name'] if I18n.transliterate(participant['name']) == player_name
    end
    return player_name
  end

  def self.send_to_room(room, message)
    room.send('PingPously', message, color: 'purple', message_format: 'text', notify: true)
  end

  def self.fetch_looser(game)
    Player.find(([game.challenged_id, game.challenger_id] - [game.winner_id]).first)
  end

  def self.fetch_defeated_word(score)
    scores = score.split(' : ').map(&:to_i)
    score_difference = scores.max - scores.min
    if (score_difference <= 5)
      'defeated'
    elsif (score_difference <= 10)
      'anihilated'
    else
      'OWNED'
    end
  end
end
