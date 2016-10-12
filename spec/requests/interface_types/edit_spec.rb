require 'rails_helper'

RSpec.describe 'InterfaceType edit payload for testing', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.admin)
    @interface_type = FactoryGirl.create(:interface_type,
                                        test_payload: '')
    @interface = FactoryGirl.create(:interface,
                                    interface_type: @interface_type)
  end

  it 'updates an interface type\s test payload' do
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    target_test_payload = '{"foo": "bar"}'

    patch interface_type_path(@interface_type),
          params: {
            interface_type: {
              id: @interface_type.id,
              test_payload: target_test_payload
            }
          }

    expect(response).to be_redirect
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)

    # interface type is expected to have a new payload
    interface_type = InterfaceType.first
    expect(interface_type.test_payload).to eq(target_test_payload)
  end

  it 'does not affect related interfaces attributes' do
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)
    expect(@interface.interface_type).to eq(@interface_type)
    target_test_payload = '{"foo": "bar"}'

    interface_title = @interface.title
    interface_associated_problem_identifiers = @interface.associated_problem_identifiers
    interface_type_id = @interface.interface_type_id
    interface_template = Paperclip.io_adapters.for(@interface.template).read
    interface_css = @interface.compiled_stylesheet
    interface_js = @interface.compiled_java_script

    patch interface_type_path(@interface_type),
          params: {
            interface_type: {
              id: @interface_type.id,
              test_payload: target_test_payload
            }
          }

    expect(response).to be_redirect
    expect(Interface.count).to eq(1)
    expect(InterfaceType.count).to eq(1)

    interface_type = InterfaceType.first
    expect(interface_type.test_payload).to eq(target_test_payload)

    interface = Interface.first
    expect(interface.title).to eq(interface_title)
    expect(interface.associated_problem_identifiers).to eq(interface_associated_problem_identifiers)
    expect(interface.interface_type_id).to eq(interface_type_id)
    expect(interface.interface_type_id).to eq(interface_type.id)
    expect(Paperclip.io_adapters.for(interface.template).read).to eq(interface_template)
    expect(interface.compiled_stylesheet).to eq(interface_css)
    expect(interface.compiled_java_script).to eq(interface_js)
  end
end
