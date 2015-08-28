class Badge < ActiveRecord::Base

  validates_presence_of :name, :image_url

  serialize :award_rule

  has_many :awards, dependent: :destroy
  has_many :players, through: :awards

  def awarded_to?(player)
  	return  player.awards.where(badge_id: self.id).count > 0
  end

  def qualifies?(player)
      return false if required_rating.nil?
      player.rating >= required_rating
  end
end
