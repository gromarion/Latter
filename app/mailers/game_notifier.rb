class GameNotifier
  def self.notify_challenged(game)
    HipChat::Client.new("PtCASLNBYvstFCyKbCTFWCpRn7DyUf1PyVv1nbRu", api_version: 'v2').user(
      game.challenged.email
    ).send("Latter: You have been challenged by #{game.challenger.name} (pingpong)")
  end

  def self.completed_game(game)
    client = HipChat::Client.new("PtCASLNBYvstFCyKbCTFWCpRn7DyUf1PyVv1nbRu", api_version: 'v2')

    recipients = [game.challenged, game.challenger].select do |p|
      p.wants_challenge_completed_notifications?
    end.map(&:email)

    return if recipients.empty?

    recipients.each do |recipient|
      client.user(recipient).send("Latter: Game has been completed! (pingpong)")
    end
  end
end
