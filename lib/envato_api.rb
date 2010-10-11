class EnvatoAPI
  private
  def get_data(url, format, &block)
    data = Net::HTTP.get_response(URI.parse(URI.encode(url))).body;
    case format
    when 'xml' then
      data = REXML::Document.new(data);
    else
      raise ArgumentError, "#{format} is not a valid data format";
    end
    data = yield data if block_given?
    return data;
  end

  def generate_url(api_command, format, params = nil)
    return "#{@base_url}/#{@api_version}/#{api_command}:#{params}.#{format}";
  end

  public
  def initialize(version = 'v2')
    @api_version = version;
    @base_url = 'http://marketplace.envato.com/api';
  end

  def get_blog_posts(site, format)
    url = generate_url('blog-posts', format, site);
    return get_data(url, format);
  end

  def get_active_threads(site, format)
    url = generate_url('active-threads', format, site);
    return get_data(url, format);
  end

  def get_number_of_files(site, format)
    url = generate_url('number-of-files', format, site);
    return get_data(url, format);
  end

  def get_popular_items(site, format)
    url = generate_url('popular', format, site);
    return get_data(url, format)
  end

  def get_user_info(user, format)
    url = generate_url('user', format, user);
    return get_data(url, format);
  end

  def get_release_info(format)
    url = generate_url('release', format);
    return get_data(url, format);
  end
  
  def get_thread_status(thread_id, format)
    url = generate_url('thread-status', format, thread_id);
    return get_data(url, format);
  end

  def get_collection_info(collection_id, format)
    url = generate_url('collection', format, collection_id);
    return get_data(url, format);
  end

  def get_site_features(site, format)
    url = generate_url('features', format, site);
    return get_data(url, format);
  end

  def get_new_files(site, format)
    url = generate_url('new-files', format, site);
    return get_data(url, format);
  end

  def get_new_files_from_user(user, format)
    url = generate_url('new-files-from-user', format, user);
    return get_data(url, format);
  end

  def get_random_new_files(site, format)
    url = generate_url('random-new-files', format, site);
    return get_data(url, format);
  end

  def get_total_users(site, format)
    url = generate_url('total-users', format, site);
    return get_data(url, format);
  end

  def search_site(site = '', type = '', search_term, format)
    url = generate_url(
      'search',
      format,
      "#{site},#{type},#{search_term}",
      format
    );
    return get_data(url, format);

  end
  def get_custom(set, format, params = nil, &block)
    url = generate_url(set, format, params);
    return get_data(url, format, &block);
  end
end