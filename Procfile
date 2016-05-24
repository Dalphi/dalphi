web: rails s puma -p 3000 -b 0.0.0.0
worker: rake jobs:work
active_learning: while true; do cat spec/fixtures/service_headers/active_learning | /bin/nc -l 3001; done
bootstrap: while true; do cat spec/fixtures/service_headers/bootstrap | /bin/nc -l 3002; done
machine_learning: while true; do cat spec/fixtures/service_headers/machine_learning | /bin/nc -l 3003; done
