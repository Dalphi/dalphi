require 'rails_helper'

RSpec.describe 'Interface creation', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.user)
  end

  it 'creates an interface' do
    expect(Interface.count).to eq(0)

    post interfaces_path,
         params: {
           interface: {
             title: 'Testtitle',
             interface_type_attributes: {
               name: 'test-type'
             },
             associated_problem_identifiers: 'ner, super_ner',
             template: '<div class="test">test</div>',
             java_script: 'console.log("test");',
             stylesheet: 'div { background-color: aqua; }'
           }
         }

    expect(response).to redirect_to(edit_interface_path(id: 1))
    expect(Interface.count).to eq(1)

    interface = Interface.first
    expect(interface.title).to eq('Testtitle')
    expect(interface.interface_type.name).to eq('test-type')
    expect(interface.associated_problem_identifiers.sort).to eq(%w(ner super_ner).sort)
    expect(Paperclip.io_adapters.for(interface.template).read).to eq('<div class="test">test</div>')
    expect(Paperclip.io_adapters.for(interface.java_script).read).to eq('console.log("test");')
    expect(Paperclip.io_adapters.for(interface.stylesheet).read).to eq('div { background-color: aqua; }')
  end
end
