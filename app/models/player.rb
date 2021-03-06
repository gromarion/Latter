class Player < ActiveRecord::Base

  PRO_K_FACTOR = 10
  STARTER_K_FACTOR = 25
  DEFAULT_K_FACTOR = 15

  # 30 games
  STARTER_BOUNDARY = 30

  # Rating
  PRO_RATING_BOUNDARY = 2400

  default_scope { where(active: true) }

  devise :trackable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates_presence_of :name, allow_blank: false
  validates_numericality_of :rating, minimum: 0
  validates_inclusion_of :pro, :starter, in: [true, false, nil]
  validates_inclusion_of :active, in: [true, false]

  has_many :challenged_games, class_name: 'Game', foreign_key: 'challenged_id', dependent: :destroy
  has_many :challenger_games, class_name: 'Game', foreign_key: 'challenger_id', dependent: :destroy
  has_many :won_games, class_name: 'Game', foreign_key: 'winner_id'

  has_many :awards, dependent: :destroy
  has_many :badges, through: :awards

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |player|
      player.email = auth.info.email
      player.name = auth.info.name
      player.image_url = auth.info.image
    end
  end

  def nemesis
    Game.where('winner_id != ? AND (challenger_id = ? OR challenged_id = ?)', id, id, id).
      group_by(&:winner_id).each do |potential_nemesis_id, nemesis_won_games|
      player_won_games = Game.where(winner_id: id).where(
        'challenger_id = ? or challenged_id = ?',
        potential_nemesis_id, potential_nemesis_id
      )
      if nemesis_won_games.size - player_won_games.size >= NEMESIS_REQUIRED_WON_GAMES
        return Player.find(potential_nemesis_id).name
      end
    end
    nil
  end

  # Public - Return all games that a player has participated in
  #
  # Returns an array of games where the player was either a challenger or
  # was challenged
  def games(complete = nil)
    games_scope = Game.where('challenger_id = ? OR challenged_id = ?', id, id)
    games_scope.includes(:challenged, :challenger)
    games_scope.where('complete = ?', complete) if complete
    games_scope = games_scope.order('created_at DESC')

    games_scope
  end

  # Public - Return the ranking of a player
  #
  # This method leverages the rating of a player to order all players
  # and returns an array index of the ordering, plus one.
  # This value can then be used to display the player's position
  # in the ladder.
  def ranking
    Player.order('rating DESC').select(:id).map(&:id).index(id) + 1
  end

  # Public - Calculate whether this player is a rookie
  #
  # Returns true if the player is a rookie, or false if not
  def starter?
    games_played < Player::STARTER_BOUNDARY
  end

  # Public - Calculate whether this player is a pro player
  #
  # Returns true if the player is a pro, or false if not
  def pro_rating?
    rating >= Player::PRO_RATING_BOUNDARY
  end

  # Public - Return games that are in progress with another player
  #
  # This method returns an array of games that are in progress
  # with a given player. It uses the existing games query to
  # build upon this and return results.
  #
  # other_player - the Player object to find in progress games with
  #
  # Returns an array of games that are in progress between this player
  # and another player
  def in_progress_games(other_player)
    games.where(
      'complete = ? AND (challenger_id = ? OR challenged_id = ?)',
      false,
      other_player.id,
      other_player.id
    )
  end

  # Public - Return the number of games played by this player
  #
  # Returns an integer count of games played by the player
  # (complete, challenger and challenged)
  def games_played
    games.size
  end

  # Public - Calculate the k-factor for the player
  #
  # Applies a basic k-factor calculation to the player
  # to arrive at a magical number. This number
  # is used to weigh a players result against how
  # developed the player is.
  #
  # Returns a decimal number representing that players
  # k-factor
  def k_factor
    if pro? || pro_rating?
      Player::PRO_K_FACTOR
    elsif starter?
      Player::STARTER_K_FACTOR
    else
      Player::DEFAULT_K_FACTOR
    end
  end

  # Public - Calcualte the trend of the player in the last 48 hours
  #
  # This method does a basic game count comparison to work out whether
  # a player is improving, unimproving, or unchanged.
  #
  # Returns:
  # - :up if the player is improving
  # - :down if the player is not improving
  # - :same if the player is neither improving nor unimproving
  def trend
    won_games_in_last_48_hours = won_games.
      where('updated_at > ?', DateTime.now - 48.hours).
      count
    lost_games_in_last_48_hours = games.
      where('updated_at > ?', DateTime.now - 48.hours).count -
      won_games_in_last_48_hours

    if won_games_in_last_48_hours > lost_games_in_last_48_hours
      return :up
    elsif lost_games_in_last_48_hours > won_games_in_last_48_hours
      return :down
    else
      return :same
    end
  end

  # Award a badge
  #
  # Award the badge to a player via an award
  #
  # Default is for the award_date datetime to be nil
  # Which means it gets set in the model to created_at
  # Player.award!(badge)
  #
  # To award on the 1st June 2012, do
  # Player.award!(badge, Date.new(2012, 6, 1))
  #
  # Expiry is a number of days from the award_date for the badge to expire
  def award!(badge, award_date = nil)
    return unless !badge.awarded_to?(self) || badge.allow_duplicates

    if badge.expire_in_days != 0
      base_date = award_date.present? ? award_date : DateTime.now
      abs_expiry = base_date.advance(days: badge.expire_in_days)
    else
      abs_expiry = nil
    end

    awards.create(badge_id: badge.id, award_date: award_date, expiry: abs_expiry)
  end

  # Private - Update player ratings based on the result
  # of a game
  #
  # This method is not part of the public Player API, but
  # is called by the Game class when a game is completed
  # and scores have been calculated.
  #
  # game - The completed, score-calculated game to
  #        use when updating the player
  #
  # Returns the player instance
  def played(game)
    self.rating = game.ratings[self].new_rating
    self.pro = true if pro_rating?
    save

    self
  end
end
