class RouteRecognizer
  # This module is inspired on a Gist from bantic
  # https://gist.github.com/bantic/5688232

  def initialize(params)
    @callee_name = params[:controller]
    @callee_action = params[:action]

    routes = Rails.application.routes.routes
    @paths = routes.collect {|r| r.path.spec.to_s }.uniq
  end

  def get_all_paths
    @paths
  end

  def initial_path_segments
    @initial_path_segments ||= begin
      @paths.collect do |path|
        path[%r{^\/([^\/\(:]+)}, 1]
      end.compact.uniq
    end
  end

  def build_path_tree # WIP
    ap "call controller: #{@callee_name}"
    ap "call action: #{@callee_action}"

    @path_tree = {}
    @paths.keep_if { |path| path.include?("/#{@callee_name}/") }
    ap @paths
  end
end
