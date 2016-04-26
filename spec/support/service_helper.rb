module ServiceHelper
  include ActiveJob::TestHelper

  def role_is_valid(model_instance, role_identifier, target_enum)
    model_instance.role = role_identifier
    expect(model_instance).to be_valid

    match_map = [true, false, false] if target_enum == 0
    match_map = [false, true, false] if target_enum == 1
    match_map = [false, false, true] if target_enum == 2

    expect(model_instance.active_learning?).to match(match_map[0])
    expect(model_instance.bootstrap?).to match(match_map[1])
    expect(model_instance.machine_learning?).to match(match_map[2])
  end

  def problem_id_is_valid(model_instance, problem_identifier, target_enum)
    model_instance.problem_id = problem_identifier
    expect(model_instance).to be_valid

    match_map = [true] if target_enum == 0

    expect(model_instance.ner?).to match(match_map[0])
  end
end
