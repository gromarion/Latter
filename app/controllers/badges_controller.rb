class BadgesController < ApplicationController
  def index
    @badges = Badge.all
    render stream: true
  end

  def show
    @badge = Badge.find(params[:id])
    render stream: true
  end
end
