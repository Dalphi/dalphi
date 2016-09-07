class StatisticsController < ApplicationController
  # GET /statistics
  def index
    @statistics = Statistic.all
  end
end
