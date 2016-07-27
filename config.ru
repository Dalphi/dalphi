# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

# Action Cable requires that all classes are loaded in advance
Rails.application.eager_load!

Rack::Utils.multipart_part_limit = 0

run Rails.application
