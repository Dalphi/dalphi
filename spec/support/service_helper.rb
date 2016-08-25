module ServiceHelper
  include ActiveJob::TestHelper

  def role_is_valid(model_instance, role_identifier, target_enum)
    model_instance.role = role_identifier
    expect(model_instance).to be_valid
    expect(model_instance.iterate?).to eq(target_enum == 0)
    expect(model_instance.merge?).to eq(target_enum == 1)
    expect(model_instance.machine_learning?).to eq(target_enum == 2)
  end
end
