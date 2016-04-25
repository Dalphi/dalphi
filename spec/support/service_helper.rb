module ServiceHelper
  include ActiveJob::TestHelper

  def roll_is_valid(model_instance, roll_identifier, target_enum)
    model_instance.roll = roll_identifier
    expect(model_instance).to be_valid

    match_map = [true, false, false] if target_enum == 0
    match_map = [false, true, false] if target_enum == 1
    match_map = [false, false, true] if target_enum == 2

    expect(model_instance.active_learning?).to match(match_map[0])
    expect(model_instance.bootstrap?).to match(match_map[1])
    expect(model_instance.machine_learning?).to match(match_map[2])
  end

  def capability_is_valid(model_instance, capability_identifier, target_enum)
    model_instance.capability = capability_identifier
    expect(model_instance).to be_valid

    match_map = [true] if target_enum == 0

    expect(model_instance.ner?).to match(match_map[0])
  end
end
