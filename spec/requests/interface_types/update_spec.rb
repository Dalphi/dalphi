require 'rails_helper'

RSpec.describe 'InterfaceType update', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @interface_type = FactoryGirl.create :interface_type
    @interface = FactoryGirl.create :interface,
                                    interface_type: @interface_type
    sign_in(@project.admin)
  end

  it "updates an interface type with valid data" do
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)

    patch interface_type_path(@interface_type),
          params: {
            interface_type: {
              id: @interface_type.id,
              test_payload: '{"new":"test","payload":1.23}'
            }
          }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(edit_interface_type_url(@interface_type))
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    interface_type = InterfaceType.first
    expect(interface_type.name).to eq(@interface_type.name)
    expect(interface_type.test_payload).to eq('{"new":"test","payload":1.23}')
  end

  it "does not update an interface type with invalid data" do
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)

    patch interface_type_path(@interface_type),
          params: {
            interface_type: {
              id: @interface_type.id,
              test_payload: '{"invalid'
            }
          }

    expect(response).to be_success
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    interface_type = InterfaceType.first
    expect(interface_type.name).to eq(@interface_type.name)
    expect(interface_type.test_payload).to eq(@interface_type.test_payload)
  end

  it 'does not affect related interfaces attributes' do
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    expect(@interface.interface_type).to eq(@interface_type)

    patch interface_type_path(@interface_type),
          params: {
            interface_type: {
              id: @interface_type.id,
              test_payload: '{"new":"test","payload":1.23}'
            }
          }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(edit_interface_type_url(@interface_type))
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    interface_type = InterfaceType.first
    expect(interface_type.test_payload).to eq('{"new":"test","payload":1.23}')
    interface = Interface.first
    expect(interface.title).to eq(@interface.title)
    expect(interface.associated_problem_identifiers).to eq(@interface.associated_problem_identifiers)
    expect(interface.interface_type_id).to eq(@interface.interface_type_id)
    expect(Paperclip.io_adapters.for(interface.template).read).to eq(Paperclip.io_adapters.for(@interface.template).read)
    expect(interface.compiled_stylesheet).to eq(@interface.compiled_stylesheet)
    expect(interface.compiled_java_script).to eq(@interface.compiled_java_script)
  end
end
