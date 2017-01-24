class StatisticsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_project, only: [:index]

  # GET /statistics
  def index
    @statistics = @project.statistics
    per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['statistics']
    per_page *= @statistics.map(&:key).uniq.count
    @statistics = @statistics.paginate(
                                page: params[:page],
                                per_page: per_page
                              )
  end

  private

  def set_project
    @project = current_role.projects.find(params[:project_id])
  end
end
