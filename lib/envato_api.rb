class EnvatoAPI
  def initialize
    @api_version = 'v2';
    @base_url = 'http://marketplace.envato.com/api';
  end
  private
  def get_data(url, format)
    data = Net::HTTP.get_response(URI.parse(URI.encode(url))).body;
    case format
    when 'xml' then
      return REXML::Document.new(data);
    end
  end
  public
  def get_popular_items_this_week(site, format)
    url = "#{@base_url}/#{@api_version}/popular:#{site}.#{format}";
    case format
    when 'xml' then
      xml_doc = get_data(url, 'xml');
      data = REXML::XPath.match(xml_doc, '//items-last-week/');
    end
    return data;
  end
  def get_custom(set, format, parameters = nil, xpath = '//')
    url = "#{@base_url}/#{@api_version}/#{set}:#{parameters}.#{format}";
    case format
    when 'xml' then
      xml_doc = self.get_data(url, 'xml');
      data = REXML::XPath.match(xml_doc, xpath);
    end
    return data;
  end
end