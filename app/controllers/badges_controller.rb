class BadgesController < ApplicationController

  BADGES_ORDER = ['Break the Ice', 'Bronze', 'Silver', 'Gold', 'Platinum']

  def index
    @badges = Badge.all
    @badges = @badges.sort { |x, y| BADGES_ORDER.index(x.name) <=> BADGES_ORDER.index(y.name) }
    render stream: true
  end

  def show
    @badge = Badge.find(params[:id])
    render stream: true
  end
end
