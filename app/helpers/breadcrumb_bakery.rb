class BreadcrumbBakery
  include Rails.application.routes.url_helpers

  def initialize(current_uri)
    @breadcrumbs = []
    @recognized_path = Rails.application.routes.recognize_path(current_uri)
    create_breadcrumbs
  rescue
  end

  def create_breadcrumbs
    partial_recognized_path = {}

    @recognized_path.each do |key, value|
      partial_recognized_path.merge!({key => value})
      key_string = key.to_s

      if key_string == 'id'
        add_tailing_breadcrumbs

      elsif key_string.end_with?('_id')
        controller_name = key_string[0..-4]

        add_breadcrumb(controller_name.pluralize,
          custom_url_for_controller(partial_recognized_path, controller_name, 'index'))

        add_breadcrumb(recognize_instance_name(controller_name, partial_recognized_path),
          custom_url_for_controller(partial_recognized_path, controller_name, 'show'))
      end
    end

    add_trivial_breadcrumb if @breadcrumbs == []
  end

  def custom_url_for_controller(path, controller, action)
    path_hash = path.clone
    controller_instance = "#{controller}_id".to_sym
    path_hash[:id] = path_hash[controller_instance] if action != 'index'
    path_hash.except!(controller_instance)

    path_hash[:controller] = controller.pluralize
    path_hash[:action] = action
    path_hash[:only_path] = true
    url_for path_hash
  end

  def custom_url_for_action(path, action)
    path_hash = path.clone
    path_hash.except!(:id) if action == 'index'

    path_hash[:action] = action
    path_hash[:only_path] = true
    url_for path_hash
  end

  def add_trivial_breadcrumb
    add_breadcrumb(@recognized_path[:controller],
      url_for(@recognized_path.merge({ only_path: true })))
  end

  def add_tailing_breadcrumbs
    add_breadcrumb(@recognized_path[:controller],
      custom_url_for_action(@recognized_path, 'index'))
    add_breadcrumb(@recognized_path[:action],
      url_for(@recognized_path.merge({ only_path: true })))
  end

  def add_breadcrumb(name, path)
    @breadcrumbs.push({
      display_name: name,
      path: path
    })
  end

  def recognize_instance_name(controller_name, recognized_path)
    # TODO: create a config file and specify attribute name and don't hardcode 'title'
    controller_instance = "#{controller_name}_id".to_sym
    instance_id = recognized_path[controller_instance]
    controller_name.classify.constantize.find(instance_id).title
  rescue
    'show'
  end

  def get_breadcrumbs
    @breadcrumbs
  end

  # The following functions might be helpful in the future!

  def get_all_paths
    routes = Rails.application.routes.routes
    @paths = routes.collect { |route| route.path.spec.to_s }.uniq
  end

  def initial_path_segments
    get_all_paths
    @paths.collect { |path| path[%r{^\/([^\/\(:]+)}, 1] }.compact.uniq
  end

  def get_currently_related_routes
    get_all_paths
    controller = "/#{@recognized_path[:controller]}/"
    action = "/#{@recognized_path[:action]}"

    relevant_paths = @paths.select { |path| path.include?(controller) }
    action_containing = relevant_paths.select { |path| path.include?(action) }

    return action_containing unless action_containing.empty?
    relevant_paths
  end
end
