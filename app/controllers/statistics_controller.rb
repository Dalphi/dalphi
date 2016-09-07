class StatisticsController < ApplicationController
  before_action :set_project, only: [:index]

  # GET /statistics
  def index
    @statistics = Statistic.where(project: @project)
    per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['statistics']
    per_page *= @statistics.map(&:key).uniq.count
    @statistics = @statistics.paginate(
                                page: params[:page],
                                per_page: per_page
                              )
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
