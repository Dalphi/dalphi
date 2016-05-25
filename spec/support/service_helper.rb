module ServiceHelper
  include ActiveJob::TestHelper

  def role_is_valid(model_instance, role_identifier, target_enum)
    model_instance.role = role_identifier
    expect(model_instance).to be_valid

    match_map = [true, false, false, false] if target_enum == 0
    match_map = [false, true, false, false] if target_enum == 1
    match_map = [false, false, true, false] if target_enum == 2
    match_map = [false, false, false, true] if target_enum == 3

    expect(model_instance.active_learning?).to match(match_map[0])
    expect(model_instance.bootstrap?).to match(match_map[1])
    expect(model_instance.machine_learning?).to match(match_map[2])
    expect(model_instance.merge?).to match(match_map[3])
  end

  def problem_id_is_valid(model_instance, problem_identifier, target_enum)
    model_instance.problem_id = problem_identifier
    expect(model_instance).to be_valid

    match_map = [true] if target_enum == 0

    expect(model_instance.ner?).to match(match_map[0])
  end

  # start static service emulations for testing against real URLs
  def port_is_open?(port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new('localhost', port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end
    return false
  end

  def spawn_service_dummy(name, port)
    if !port_is_open?(port)
      fixture_path = 'spec/fixtures/service_headers'
      command = 'nc -l'
      spawn "while true; do cat #{fixture_path}/#{name} | #{command} #{port}; done"
    end
  end
end
