class RouteRecognizer
  # This module is inspired on a Gist from bantic
  # https://gist.github.com/bantic/5688232

  def initialize(params)
    routes = Rails.application.routes.routes
    @paths = routes.collect { |route| route.path.spec.to_s }.uniq
    build_path_tree(params[:controller], params[:action])
  end

  def get_all_paths
    @paths
  end

  def initial_path_segments
    @initial_path_segments ||= begin
      @paths.collect { |path| path[%r{^\/([^\/\(:]+)}, 1] }.compact.uniq
    end
  end

  def build_path_tree(callee_name, callee_action) # WIP
    ap "call controller: #{callee_name}"
    ap "call action: #{callee_action}"

    @paths.keep_if { |path| path.include?("/#{callee_name}/") }
    ap @paths
  end
end
