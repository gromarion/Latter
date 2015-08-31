class GameNotifier
  def self.notify_challenged(game)
    HIPCHAT_CLIENT.user(game.challenged.email).send(
      "PingPously: You have been challenged by #{game.challenger.name} (pingpong)"
    )
    room = HIPCHAT_CLIENT[PING_PONG_ROOM_NAME]
    challenged_mention = fetch_hipchat_mention(game.challenged, room)
    challenger_mention = fetch_hipchat_mention(game.challenger, room)
    if challenged_mention && challenger_mention
      send_to_room(room, "@#{challenger_mention} has challenged @#{challenged_mention} to play (pingpong)!")
    end
  end

  def self.notify_completed_game(game)
    winner = Player.find(game.winner_id)
    loser = fetch_looser(game)
    room = HIPCHAT_CLIENT[PING_PONG_ROOM_NAME]
    winner_mention = fetch_hipchat_mention(winner, room)
    loser_mention = fetch_hipchat_mention(loser, room)
    defeated = fetch_defeated_word(game)
    if winner_mention && loser_mention
      send_to_room(
        HIPCHAT_CLIENT[PING_PONG_ROOM_NAME],
        "@#{winner_mention} #{defeated} @#{loser_mention} #{game.final_score}"
      )
    end
    HIPCHAT_CLIENT.user(loser.email).send(
      "PingPously: You have been #{defeated} by #{winner.name} #{game.final_score}"
    )
    HIPCHAT_CLIENT.user(winner.email).send(
      "PingPously: You have #{defeated} #{loser.name} #{game.final_score}"
    )
  end

  def self.show_off(player)
    if player.ranking >= 1 && player.ranking <= 10
      room = HIPCHAT_CLIENT[PING_PONG_ROOM_NAME]
      player_mention = fetch_hipchat_mention(player, room)
      room.send('')
    end
  end

  private

  def self.fetch_hipchat_mention(player, room)
    return player.mention if player.mention
    player_name = I18n.transliterate(player.name).downcase
    room.get_room['participants'].each do |participant|
      return participant['mention_name'] if I18n.transliterate(participant['name']).downcase == player_name
    end
    player_name
  end

  def self.send_to_room(room, message)
    room.send('PingPously', message, color: 'purple', message_format: 'text', notify: true)
  end

  def self.fetch_looser(game)
    Player.find(([game.challenged_id, game.challenger_id] - [game.winner_id]).first)
  end

  def self.fetch_defeated_word(game)
    score_difference = game.winner_score - game.loser_score
    if (score_difference <= 5)
      'defeated'
    elsif (score_difference <= 10)
      'anihilated'
    else
      'OWNED'
    end
  end
end
