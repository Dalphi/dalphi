require 'rails_helper'

RSpec.describe "GET routes", type: :request do
  before(:each) do
    @annotation_document = FactoryGirl.create :annotation_document
    @statistic = FactoryGirl.create :statistic
    @raw_datum = @annotation_document.raw_datum
    @project = @raw_datum.project
    @admin = @project.admin

    @iterate_service = FactoryGirl.create :iterate_service
    @merge_service = FactoryGirl.create :merge_service
    @interface = FactoryGirl.create :interface

    @annotator = FactoryGirl.create :annotator

    @project.iterate_service = @iterate_service
    @project.merge_service = @merge_service
    @project.interfaces = [@interface]
    @project.save!

    sign_in(@admin)
  end

  it 'should be error-free' do
    routes = ROUTES.select { |r| r[:method] == 'GET' }
    routes.each do |route|
      path = route[:path]
      path.gsub!(/:role/, 'iterate')
      path.gsub!(/:annotation_document_id/, '1')
      get path
      next if response.status == 401 && path.include?('api/v1')
      expect([200, 301, 302]).to include(response.status)
    end
  end

  ROUTES = Rails.application.routes.routes.map do |route|
    path = route.path.spec.to_s.gsub(/\(\.:format\)/, '').gsub(/:([a-zA-Z]+_){0,1}id/, '1')
    method = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first
    { path: path, method: method }
  end
end
