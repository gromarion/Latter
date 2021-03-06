class StatisticsController < ApplicationController
  respond_to :html, :json

  def index
    @data = Game.statistics

    respond_to do |format|
      format.html { render stream: true }
      format.json { render }
    end
  end
end
