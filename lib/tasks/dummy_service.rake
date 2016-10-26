namespace :dummy_service do
  desc 'iterate dummy service'
  task iterate: :environment do
    while true do
      `nc -l 3001 < #{Rails.root}/spec/fixtures/service_headers/iterate`
    end
  end

  desc 'merge dummy service'
  task merge: :environment do
    while true do
      `nc -l 3002 < #{Rails.root}/spec/fixtures/service_headers/merge`
    end
  end

  desc 'machine learning dummy service'
  task machine_learning: :environment do
    while true do
      `nc -l 3003 < #{Rails.root}/spec/fixtures/service_headers/machine_learning`
    end
  end
end
