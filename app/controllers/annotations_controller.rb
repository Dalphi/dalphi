class AnnotationsController < ApplicationController
  before_action :set_project,
                only: [
                  :annotate
                ]

  # GET /projects/1/annotate
  def annotate
    if @project.annotation_documents.empty?
      flash[:alert] = I18n.t 'projects.annotate.errors.no-annotation-documents'
      redirect_to project_path(@project)
    end

    @container_class = Rails.configuration.x.dalphi['annotation-interface']['container-class-name']
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
