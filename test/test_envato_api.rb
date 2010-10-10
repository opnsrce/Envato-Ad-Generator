require 'test/unit'
require 'net/http';
require 'uri';
require 'rexml/document';
require 'RMagick';
require 'json';
require './lib/envato_api.rb';

class EnvatoAPITest < Test::Unit::TestCase

  def check_element_for_nodes(element, nodes)
    nodes.each do |node|
      assert_not_nil(element.elements[node], "#{element.name} is lacking a <#{node}> element");
    end
  end

  def test_blog_post_xml
    envato_api = EnvatoAPI.new;
    blog_posts = envato_api.get_blog_posts('activeden', 'xml');
    assert_instance_of(REXML::Document, blog_posts);
    blog_posts.each_element('//blog-post') do |blog_post|
       self.check_element_for_nodes(blog_post, ['posted-at', 'url', 'site', 'title']);
    end if assert(REXML::XPath.match(blog_posts, '//blog-post').size > 0, 'No blog post nodes found');
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { envato_api.get_blog_posts('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { envato_api.get_blog_posts('activeden', 'xml'); }
  end

  def test_get_active_threads_xml
    envato_api = EnvatoAPI.new;
    active_threads = envato_api.get_active_threads('activeden', 'xml');
    assert_instance_of(REXML::Document, active_threads);
    active_threads.each_element('//active-thread') do |active_thread|
      assert_not_nil(active_thread.elements['url'], 'active thread is lacking <url> element');
      assert_not_nil(active_thread.elements['title'], 'active thread is lacking <title> element');
    end
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { envato_api.get_active_threads('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { envato_api.get_active_threads('activeden', 'xml'); }
  end

  def test_get_number_of_files_xml
    envato_api = EnvatoAPI.new;
    number_of_files = envato_api.get_number_of_files('activeden', 'xml');
    assert_instance_of(REXML::Document, number_of_files);
    number_of_files.each_element('//number-of-file') do |number_of_file|
      assert_not_nil(number_of_file.elements['category'], 'number of file is lacking <category> element');
      assert_not_nil(number_of_file.elements['number-of-files'], 'number of file is lacking <number-of-files> element');
      assert_not_nil(number_of_file.elements['url'], 'number of file is lacking <url> element');
    end
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { envato_api.get_number_of_files('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { envato_api.get_number_of_files('activeden', 'xml'); }
  end

  def test_get_popular_items_xml
    envato_api = EnvatoAPI.new;
    popular_items = envato_api.get_popular_items('activeden', 'xml');
    assert_instance_of(REXML::Document, popular_items);
    popular_items.each_element('//popular') do |popular_item|
      assert_not_nil(popular_item.elements['items-last-three-months'], 'popular item is lacking <items-last-three-months> element');
      popular_item.each_element('items-last-three-months/items-last-three-month') do |item_last_three_month|
        assert_not_nil(item_last_three_month.elements['user'], 'item last three month is lacking <user> element');
        assert_not_nil(item_last_three_month.elements['rating'], 'item last three month is lacking <rating> element');
        assert_not_nil(item_last_three_month.elements['thumbnail'], 'item last three month is lacking <thumbnail> element');
        assert_not_nil(item_last_three_month.elements['url'], 'item last three month is lacking <url> element');
        assert_not_nil(item_last_three_month.elements['cost'], 'item last three month is lacking <cost> element');
        assert_not_nil(item_last_three_month.elements['sales'], 'item last three month is lacking <sales> element');
        assert_not_nil(item_last_three_month.elements['id'], 'item last three month is lacking <id> element');
        assert_not_nil(item_last_three_month.elements['uploaded-on'], 'item last three month is lacking <uploaded-on> element');
        assert_not_nil(item_last_three_month.elements['item'], 'item last three month is lacking <item> element');
      end if assert_not_nil(popular_item.elements['items-last-three-months/items-last-three-month'], 'popular item has no <items-last-three-month> elements')
      assert_not_nil(popular_item.elements['items-last-week'], 'popular item is lacking <items-last-week> element');
      popular_item.each_element('items-last-week/items-last-week') do |item_last_week|
        assert_not_nil(item_last_week.elements['user'], 'item last week is lacking <user> element');
        assert_not_nil(item_last_week.elements['rating'], 'item last week is lacking <rating> element');
        assert_not_nil(item_last_week.elements['thumbnail'], 'item last week is lacking <thumbnail> element');
        assert_not_nil(item_last_week.elements['url'], 'item last week is lacking <url> element');
        assert_not_nil(item_last_week.elements['cost'], 'item last week is lacking <cost> element');
        assert_not_nil(item_last_week.elements['sales'], 'item last week is lacking <sales> element');
        assert_not_nil(item_last_week.elements['id'], 'item last three month is lacking <id> element');
        assert_not_nil(item_last_week.elements['uploaded-on'], 'item last week is lacking <uploaded-on> element');
        assert_not_nil(item_last_week.elements['item'], 'item last week is lacking <item> element');
      end if assert_not_nil(popular_item.elements['items-last-week/items-last-week'], 'popular item has no <items-last-week> elements')
      assert_not_nil(popular_item.elements['authors-last-month'], 'popular item is lacking <authors-last-month> element');
      popular_items.each_element('authors-last-month') do |author_last_month|
        assert_not_nil(author_last_month.elements['url'], 'author last month is lacking <url> element')
        assert_not_nil(author_last_month.elements['image'], 'author last month is lacking <image> element')
        assert_not_nil(author_last_month.elements['sales'], 'author last month is lacking <sales> element')
        assert_not_nil(author_last_month.elements['item'], 'author last month is lacking <item> element')
      end if assert_not_nil(popular_item.elements['authors-last-month/authors-last-month'], 'popular item has no <authors-last-month> elements')
    end

      # Make sure that a method call with a bad format type raises the right error
      assert_raise(ArgumentError) { envato_api.get_popular_items('activeden', 'bad_format'); }
      # Make sure that a method call with a valid format type does not raise an error
      assert_nothing_raised { envato_api.get_popular_items('activeden', 'xml'); }
    end

  def test_get_user_info_xml
    envato_api = EnvatoAPI.new;
    popular_items = envato_api.get_popular_items('activeden', 'xml');
  end
end