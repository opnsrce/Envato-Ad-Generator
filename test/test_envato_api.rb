$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'net/http';
require 'uri';
require 'rexml/document';
require 'RMagick';
require 'json';
require 'envato_api.rb';

class EnvatoAPITest < Test::Unit::TestCase
  def setup
    @envato_api = EnvatoAPI.new('v2');
  end
  def teardown
    
  end
  def check_element_for_nodes(element, nodes)
    nodes.each do |node|
      assert_not_nil(element.elements[node], "<#{element.name}> is lacking a <#{node}> element");
    end
  end

  def test_get_blog_post_xml
    rexml_doc = @envato_api.get_blog_posts('activeden', 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//blog-posts') do |blog_posts|
      self.check_element_for_nodes(blog_posts, ['posted-at', 'url', 'site', 'title']);
    end if !self.check_element_for_nodes(rexml_doc.root, ['blog-posts'])
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { @envato_api.get_blog_posts('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { @envato_api.get_blog_posts('activeden', 'xml'); }
  end

  def test_get_active_threads_xml
    rexml_doc = @envato_api.get_active_threads('activeden', 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//active-threads') do |active_threads|
      active_threads.each_elment('active-thread') do |active_thread|
      end if !self.check_element_for_nodes(active_threads, ['active-thread'])
    end if !self.check_element_for_nodes(rexml_doc.root, ['active-threads']);
    assert_raise(ArgumentError) { @envato_api.get_active_threads('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { @envato_api.get_active_threads('activeden', 'xml'); }
  end

  def test_get_number_of_files_xml
    rexml_doc = @envato_api.get_number_of_files('activeden', 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//number-of-files') do |number_of_files|
      number_of_files.each_element('number-of-file') do |number_of_file|
        self.check_element_for_nodes(number_of_file, ['category', 'number-of-files', 'url'])
      end if !self.check_element_for_nodes(number_of_files, ['number-of-file']);
    end if !self.check_element_for_nodes(rexml_doc.root, ['number-of-files'])
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { @envato_api.get_number_of_files('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { @envato_api.get_number_of_files('activeden', 'xml'); }
  end

  def test_get_popular_items_xml
    @envato_api = EnvatoAPI.new;
    rexml_doc = @envato_api.get_popular_items('activeden', 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    item_nodes = ['user', 'rating', 'thumbnail', 'url', 'cost', 'sales', 'id', 'uploaded-on', 'item'];
      rexml_doc.root.each_element('//popular') do |popular|
        popular.each_element('items-last-three-months') do |item_last_three_months|
          item_last_three_months.each_element('item-last-three-months') do |item|
            self.check_element_for_nodes(item, item_nodes);
          end if !self.check_element_for_nodes(item_last_three_months, ['item-last-three-months'])
        end if !self.check_element_for_nodes(popular, ['item-last-three-months'])
      end if !self.check_element_for_nodes(rexml_doc.root, ['popular'])
    # Make sure that a method call with a bad format type raises the right error
    assert_raise(ArgumentError) { @envato_api.get_popular_items('activeden', 'bad_format'); }
    # Make sure that a method call with a valid format type does not raise an error
    assert_nothing_raised { @envato_api.get_popular_items('activeden', 'xml'); }
  end

  def test_get_user_info_xml
    @envato_api = EnvatoAPI.new;
    rexml_doc = @envato_api.get_user_info('collis', 'xml');
    rexml_doc.root.each_element('//user') do |user|
      self.check_element_for_nodes(user,  ['username', 'country', 'location', 'image', 'sales'])
    end if !self.check_element_for_nodes(rexml_doc.root, ['user'])
  end
end