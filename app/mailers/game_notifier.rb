class GameNotifier
  def self.notify_challenged(game)
    client = HipChat::Client.new("Wn2YmsDS5mPgnljLdst2u5zAGhhuMTKTJVQARn4J", api_version: 'v2')
    client.user(game.challenged.email).send(
      "PingPously: You have been challenged by #{game.challenger.name} (pingpong)"
    )
    fetch_hipchat_mention(game.challenger.name, game.challenged.name, client)
  end

  def self.completed_game(game)
    client = HipChat::Client.new("Wn2YmsDS5mPgnljLdst2u5zAGhhuMTKTJVQARn4J", api_version: 'v2')

    recipients = [game.challenged, game.challenger].select do |p|
      p.wants_challenge_completed_notifications?
    end.map(&:email)

    return if recipients.empty?

    recipients.each do |recipient|
      client.user(recipient).send("PingPously: Game has been completed! (pingpong)")
    end
  end

  private

  def self.fetch_hipchat_mention(challenger, challenged, client)
    room = client['Ping Pong']
    room.get_room()["participants"].each do |participant|
      if participant["name"] == challenged
        room.send(
          'PingPously',
          "@#{participant['mention_name']} you have been challenged by #{challenger} (pingpong)",
          color: 'purple',
          message_format: 'text',
          notify: true
        )
      end
    end
  end
end
