module ServiceHelper
  include ActiveJob::TestHelper

  def role_is_valid(model_instance, role_identifier, target_enum)
    model_instance.role = role_identifier
    expect(model_instance).to be_valid
    expect(model_instance.active_learning?).to eq(target_enum == 0)
    expect(model_instance.bootstrap?).to eq(target_enum == 1)
    expect(model_instance.machine_learning?).to eq(target_enum == 2)
    expect(model_instance.merge?).to eq(target_enum == 3)
  end

  def problem_id_is_valid(model_instance, problem_identifier, target_enum)
    model_instance.problem_id = problem_identifier
    expect(model_instance).to be_valid
    expect(model_instance.ner?).to eq(target_enum == 0)
  end
end
