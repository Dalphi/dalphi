web: bundle exec rails s puma -p 3000 -b 0.0.0.0
worker: bundle exec rake jobs:work

active_learning: while true; do cat spec/fixtures/service_headers/active_learning | nc -l 3001; done
bootstrap: while true; do cat spec/fixtures/service_headers/bootstrap | nc -l 3002; done
machine_learning: while true; do cat spec/fixtures/service_headers/machine_learning | nc -l 3003; done

api-doc: cd public && http-server --cors || true
