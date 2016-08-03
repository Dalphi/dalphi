require 'rails_helper'

RSpec.describe "GET routes", type: :request do
  before(:each) do
    @annotation_document = FactoryGirl.create :annotation_document
    @raw_datum = @annotation_document.raw_datum
    @project = @raw_datum.project
    @user = @project.user

    @bootstrap_service = FactoryGirl.create :bootstrap_service
    @merge_service = FactoryGirl.create :merge_service
    @interface = FactoryGirl.create :interface

    @project.bootstrap_service = @bootstrap_service
    @project.merge_service = @merge_service
    @project.interfaces = [@interface]
    @project.save!

    sign_in(@user)
  end

  it 'should be error-free' do
    blacklist = %w(/projects/1/bootstrap /projects/1/merge)
    routes = ROUTES.select { |r| r[:method] == 'GET' }
    routes.each do |route|
      path = route[:path]
      path.gsub!(/:role/, 'bootstrap')
      next if blacklist.include?(path)
      get path
      expect([200, 301, 302]).to include(response.status)
    end
  end

  ROUTES = Rails.application.routes.routes.map do |route|
    path = route.path.spec.to_s.gsub(/\(\.:format\)/, '').gsub(/:([a-zA-Z]+_){0,1}id/, '1')
    method = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first
    { path: path, method: method }
  end
end
