require 'rails_helper'

RSpec.describe 'Annotator create', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @annotator = FactoryGirl.build :annotator
    sign_in(@project.admin)
  end

  it 'creates a annotator without a password' do
    expect(Annotator.count).to eq(0)

    post annotators_path,
         params: {
           annotator: {
             name: 'John without password',
             email: 'own-password-john@example.com'
           }
         }

    expect(Annotator.count).to eq(1)
    annotator = Annotator.first
    expect(annotator.name).to eq('John without password')
    expect(annotator.email).to eq('own-password-john@example.com')
  end

  it 'creates a annotator with a password' do
    expect(Annotator.count).to eq(0)

    post annotators_path,
         params: {
           annotator: {
             name: 'John with password',
             email: 'lazy-john@example.com',
             password: '12345678'
           }
         }

    expect(Annotator.count).to eq(1)
    annotator = Annotator.first
    expect(annotator.name).to eq('John with password')
    expect(annotator.email).to eq('lazy-john@example.com')
  end

  it 'does not create a annotator with invalid data' do
    expect(Annotator.count).to eq(0)

    post annotators_path,
         params: {
           annotator: {
             name: 'John with invalid email',
             email: 'invalid-john@'
           }
         }

    expect(Annotator.count).to eq(0)
  end
end
