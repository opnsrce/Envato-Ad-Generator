require 'net/http';
require 'uri';
require 'rexml/document';
require 'RMagick';

# A simple class designed to interact with the Envato API
# To learn more visit http://wiki.envato.com/community/the-api/the-envato-marketplace-api/
# or http://marketplace.envato.com/api/documentation the API's documentation
#
# Note to Users/Maintainers
# * This class currently does not support the JSON format. I hope to add support soon

class EnvatoAPI
  private
  # Retrieves the response from a URL in the requested format
  # 
  # * url (string): The URL that NET::HTTP will be going to to retrive the response
  # * format (string): The format the response should be returned in (See 'format' case statement for supported values)
  # * &block (code block): An optional code block that can be passed in to perform additional actions on the data
  #   before it is returned to the calling method
  
  def get_data(url, format, &block)
    data = Net::HTTP.get_response(URI.parse(URI.encode(url))).body;
    case format
    when 'xml' then
      # Wrap the Rexml declaration in a rescue block to prevent an exception if `data` contains invalid XML
      begin
        data = REXML::Document.new(data);
      rescue
        raise TypeError, 'Unable to return Rexml Document: XML may be invalid: ' << data;
      end
    else
      raise ArgumentError, "#{format} is not a valid data format";
    end
    # If block passed in, run block and pass in data
    data = yield data if block_given?
    return data;
  end
  
  # Generates the URL used by get_data
  def generate_url(api_command, format, params = nil)
      # @base_url and @api_version are declared in initialize()
    return "#{@base_url}/#{@api_version}/#{api_command}:#{params}.#{format}";
  end

  public
  # Class constructor
  # * version (string): Specifies what version of the API you want to use. See offical documentation for details
  def initialize(version = 'v2')
    @api_version = version; # Used by generate_url
    @base_url = 'http://marketplace.envato.com/api'; # Used by generate_url
  end

  # Retrieves the 'blog-post' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_blog_posts('activeden', 'xml')
  def get_blog_posts(site, format)
    url = generate_url('blog-posts', format, site);
    return get_data(url, format);
  end
  
  # Retrieves the 'active-threads' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_active_threads('activeden', 'xml')
  def get_active_threads(site, format)
    url = generate_url('active-threads', format, site);
    return get_data(url, format);
  end
  # Retrieves the 'number-of-files' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_number_of_files('activeden', 'xml')
  def get_number_of_files(site, format)
    url = generate_url('number-of-files', format, site);
    return get_data(url, format);
  end

  # Retrieves the 'popular' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_popular_items('activeden', 'xml')
  def get_popular_items(site, format)
    url = generate_url('popular', format, site);
    return get_data(url, format)
  end

  # Retrieves the 'user' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_user_info('activeden', 'xml')
  def get_user_info(user, format)
    url = generate_url('user', format, user);
    return get_data(url, format);
  end

  # Retrieves the 'release' set in the given format.
  # * This function is really only used by Envato to generate the API documentation found at http://marketplace.envato.com/api/documentation.
  #   Knock yourself out.
  # * Usage: my_envato_api_instance.get_release_info('xml')
  def get_release_info(format)
    url = generate_url('releases', format);
    return get_data(url, format);
  end

  # Retrieves the 'thread-status' set for the given thread ID the given format
  # * Usage: my_envato_api_instance.get_thread_status('123456789', 'xml')
  def get_thread_status(thread_id, format)
    url = generate_url('thread-status', format, thread_id);
    return get_data(url, format);
  end

  # Retrieves the 'collection' set for the given collection ID in the given format
  # * Usage: my_envato_api_instance.collection_info('123456789', 'xml')
  def get_collection_info(collection_id, format)
    url = generate_url('collection', format, collection_id);
    return get_data(url, format);
  end
  # Retrieves the 'features set for the given site in the given format
  # * Usage: my_envato_api_instance.get_site_features('activeden', 'xml')
  # * <strong>NOTE:</strong> As of version 2 (v2) of the Envato API, this function <strong>does not</strong> work. It has nothing to do with my code,
  #   there's a bug in the Envato API
  def get_site_features(site, format)
    url = generate_url('features', format, site);
    return get_data(url, format);
  end

  # Retrieves the 'new-files' set for the given site, in one of that site's categories, in the given format
  # * Usage: my_envato_api_instance.get_new_files('graphicriver', 'site-templates', 'xml')
  def get_new_files(site, category, format)
    url = generate_url('new-files', format, "#{site},#{category}");
    return get_data(url, format);
  end

  # Retrieves the 'new-files-from-user' set for the given site, by the given user, in the given format
  # * Usage: my_envato_api_instance.get_new_files('collis', 'themeforest', 'xml')
  def get_new_files_from_user(user, site, format)
    url = generate_url('new-files-from-user', format, "#{user},#{site}");
    return get_data(url, format);
  end
  
  # Retrieves the 'popular' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_popular_items('activeden', 'xml')
  def get_random_new_files(site, format)
    url = generate_url('random-new-files', format, site);
    return get_data(url, format);
  end
  
  # Retrieves the 'total-users' set for the given site in the given format
  # * Usage: my_envato_api_instance.get_total_users('activeden', 'xml')
  def get_total_users(site, format)
    url = generate_url('total-users', format, site);
    return get_data(url, format);
  end
  # From the Envato API Documentation:
  #  Search for items, users or forum messages. Returns only the first 50 results.
  #  First parameter is site (e.g. activeden, audiojungle), second parameter is
  #  type (e.g. site-templates, music, graphics, for a full list of types,
  #  look at the search select box values on the particular marketplace), third paramater is
  #  the search term (e.g. xml, preloader, dance, sky). First and second parameters are optional,
  #  third is required.
  #  Examples
  #  * search:themeforest,site-templates,xml.json search:,,collis.xml
  #  * search:audiojungle,,happy.xml
  # Usage
  # * my_envato_api_instance.search_site('themeforest', 'site-templates', 'collis', 'xml)
  # * my_envato_api_instance.search('audiojungle', '', 'happy', 'xml')
  # * my_envato_api_instance.search('', 'site-templates', 'happy', 'xml')
  # * EnvatoAPIInstance.search('', '' 'happy', 'xml')
  
  def search_site(site = '', type = '', search_term, format)
    url = generate_url('search', format, "#{site},#{type},#{search_term}");
    return get_data(url, format);
  end
  # Allows for calls to the Envato API using commands that may not be directly available in this class
  # (i.e., A new method has been added to the API that this class doesn't have a get_* call for
  #
  # * set (string): The set you want to call up from the API
  # * format (string): The format you want the data to be returned in (must be supported by get_data)
  # * params (string): Additional parameters that should be passed with the set (e.g. 'collis,site-templates')
  # * &block (block): Bock of logic that the data will be passed through before being returned
  # Useage
  # * my_envato_api_instance.get_custom('custom-set', 'xml', 'collis', { |set_data| puts 'I got my ' << set_data })
  def get_custom(set, format, params = nil, &block)
    url = generate_url(set, format, params);
    return get_data(url, format, &block);
  end
end