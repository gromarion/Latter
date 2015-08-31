class Award < ActiveRecord::Base

  # default_scope to ignore expired awards
  default_scope -> { where('expiry >= ? or expiry is null', DateTime.now.midnight) }

  after_create :set_award_date

  validates_presence_of :badge_id, :player_id

  belongs_to :badge
  belongs_to :player, touch: true

  private

  def set_award_date
    if award_date.blank?
      self.award_date = created_at
      save
    end
  end
end
