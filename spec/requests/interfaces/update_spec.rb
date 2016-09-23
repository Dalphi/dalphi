require 'rails_helper'

RSpec.describe 'Interface update', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @interface = FactoryGirl.create(:interface)
    sign_in(@project.admin)
  end

  it 'updates an interface' do
    expect(Interface.count).to eq(1)

    put interface_path(@interface),
        params: {
          interface: {
            id: @interface.id,
            title: 'Testtitle',
            interface_type: {
              name: 'test-type'
            },
            associated_problem_identifiers: 'ner, super_ner',
            template: '<div class="test">test</div>',
            java_script: 'console.log("test");',
            stylesheet: 'div { background-color: aqua; }'
          }
        }

    expect(response).to be_success
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
