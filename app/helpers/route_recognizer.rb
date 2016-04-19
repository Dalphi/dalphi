class RouteRecognizer
  # This module is inspired on a Gist from bantic
  # https://gist.github.com/bantic/5688232

  def initialize(params)
    routes = Rails.application.routes.routes
    @paths = routes.collect {|r| r.path.spec.to_s }.uniq
  end

  def get_all_paths
    ap params.require(:project)
    @paths
  end

  def initial_path_segments
    @initial_path_segments ||= begin
      @paths.collect do |path|
        path[%r{^\/([^\/\(:]+)}, 1]
      end.compact.uniq
    end
  end

  def build_path_tree
    @path_tree = {}
    # @paths.each do |path|
    #   if
    # end
  end
end
