dalphi_config_path = Rails.root.join('config', 'dalphi.yml')
ap dalphi_config_path
Rails.application.config.dalphi = YAML.load_file(dalphi_config_path)[Rails.env].with_indifferent_access
ap YAML.load_file(dalphi_config_path)
ap Rails.application.config.dalphi
