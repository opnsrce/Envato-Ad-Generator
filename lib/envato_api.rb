class EnvatoAPI
  def initialize(version = 'v2')
    @api_version = version;
    @base_url = 'http://marketplace.envato.com/api';
  end
  private
  def get_data(url, format, &block)
    data = Net::HTTP.get_response(URI.parse(URI.encode(url))).body;
    case format
    when 'xml' then
      data = REXML::Document.new(data);
    end
    data = yield data if block_given?
    return data;
  end
  def generate_url(api_command, format, params = nil)
    return "#{@base_url}/#{@api_version}/#{api_command}:#{params}.#{format}";
  end
  public
  def get_blog_posts(site, format)
    url = generate_url('blog-posts', format, site);
    return get_data(url, format);
  end

  def get_popular_items_last_week(site, format)
    url = generate_url('popular', format, site);
    case format
    when 'xml' then
      data = get_data(url,format) {
        |xml_doc| return REXML::XPath.match(xml_doc, '//items-last-week/')
      };
    end
    return data;
  end
  def get_custom(set, format, params = nil, &block)
    url = generate_url(set, format, params);
    return get_data(url, format, &block);
  end
end