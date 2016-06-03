class BreadcrumbBakery
  include Rails.application.routes.url_helpers

  def initialize(request)
    tokens = url_tokens(request.original_url)
    @breadcrumbs = []
    subpath = ''
    tokens.each do |token|
      subpath << "#{token}"
      @breadcrumbs << { labelize(tokens, token) => subpath.clone }
    end
  end

  def url_tokens(original_url)
    original_path = url_to_path(original_url)
    url_tokens = original_path.split('/')
    url_tokens -= ['']
    condense_url_tokens(url_tokens)
  end

  def url_to_path(url)
    url
      .gsub(/^http(|s):\/\/[^\/]+(|:[0-9]+)/, '') # remove protocol, domain and port
      .gsub(/\?.*$/, '')                          # remove get attributes
  end

  def condense_url_tokens(url_tokens)
    condensed_tokens = []
    token_set = ''
    url_tokens.each do |token|
      token_set << "/#{token}"
      if path_exists?("#{condensed_tokens.join('/')}#{token_set}")
        condensed_tokens << token_set
        token_set = ''
      end
    end
    condensed_tokens
  end

  def path_exists?(path)
    Rails.application.routes.recognize_path(path)
  rescue
    false
  end

  def labelize(tokens, token)
    token['/'] = ''
    if is_integer?(token)
      return predecessor(tokens, token)
               .singularize
               .classify
               .constantize
               .find(token)
               .label rescue token
    elsif is_class?(token)
      return token
               .classify
               .constantize
               .model_name
               .human
               .pluralize
    elsif is_integer_and_action?(token)
      token_chunks = token.split('/')
      id = token_chunks.first
      action = token_chunks.second
      model = predecessor(tokens, token)
                .singularize
                .classify
                .constantize
                .find(id)
                .label rescue id
      return I18n.t("helpers.submit.#{action}", model: model)
    elsif is_action?(token)
      return I18n.t("helpers.actions.#{token}")
    end
    token
  end

  def predecessor(array, item)
    array[array.find_index(item) - 1]
  rescue
    nil
  end

  def is_integer?(object)
    Integer(object)
  rescue
    false
  end

  def is_class?(klass)
    klass.classify.constantize
  rescue
    false
  end

  def is_integer_and_action?(integer_and_action)
    return integer_and_action if integer_and_action =~ /[0-9]+\/\S+/
    false
  end

  def is_action?(action)
    return action if %w(edit new).include?(action)
  end

  def breadcrumbs
    @breadcrumbs
  end
end
