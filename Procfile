web: rails s puma -p 3000 -b 0.0.0.0
worker: rake jobs:work
iterate: while true; do nc -l 3001 < spec/fixtures/service_headers/iterate; done
merge: while true; do nc -l 3002 < spec/fixtures/service_headers/merge; done
machine_learning: while true; do nc -l 3003 < spec/fixtures/service_headers/machine_learning; done
