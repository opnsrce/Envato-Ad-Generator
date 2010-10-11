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
    rexml_doc = @envato_api.get_user_info('collis', 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//user') do |user|
      self.check_element_for_nodes(user,  ['username', 'country', 'location', 'image', 'sales']);
    end if !self.check_element_for_nodes(rexml_doc.root, ['user'])
  end
  def test_get_release_info_xml
    rexml_doc = @envato_api.get_release_info('xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//releases') do |releases|
      releases.each_element('release') do |release|
        release.each_element('private-chunks') do |private_chunks|
          private_chunks.each_element('private-chunk') do |private_chunk|
            self.check_element_for_nodes(private_chunk ['ttl', 'description', 'label']);
          end if !self.check_element_for_nodes(private_chunks, ['private-chunk']);
        end if !self.check_element_for_nodes(releases, ['private-chunks'])
      end if !self.check_element_for_nodes(releases, ['release'])
    end if !self.check_element_for_nodes(rexml_doc.root, ['releases'])
  end
  def test_get_thread_status_xml
    rexml_doc = @envato_api.get_thread_status(32829, 'xml');
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//thread_status') do |thread_status|
      self.check_element_for_nodes(thread_status, ['last-reply-by', 'replies', 'url', 'title', 'last-reply']);
    end if !self.check_element_for_nodes(rexml_doc.root, ['thread-status'])
  end
  def test_get_collection_info_xml
    rexml_doc = @envato_api.get_collection_info(128701, 'xml')
    assert_instance_of(REXML::Document, rexml_doc);
    rexml_doc.root.each_element('//collection') do |collections|
      collections.each_element('collection') do |collection|
        self.check_element_for_nodes(collection, ['user', 'cost', 'rating', 'thumbnail', 'url', 'sales', 'id'])
      end if !self.check_element_for_nodes(collections, ['collection'])
    end if !self.check_element_for_nodes(rexml_doc.root, ['collection'])
  end
  def test_get_site_features_xml
    # As of 10/11/2010 the 'features' command for the envato API is broken. It currently returns the following:
    # error: undefined method `to_api_hash' for #<featured::weekly:0xa4cb300>
    # If this test fails, it more than likely means that the function is now working properly
    # and this test needs to be revised
    assert_raise(TypeError) { @envato_api.get_site_features('activeden', 'xml') }
  end

  def test_get_new_files_xml
    rexml_doc = @envato_api.get_new_files('themeforest', 'site-templates', 'xml')
    assert_instance_of(REXML::Document, rexml_doc);
    assert_nil(rexml_doc.root.elements['error'], 'API returned error response: Check your parameters');
    rexml_doc.root.each_element('//new-files') do |new_files|
      new_files.each_element('new-file') do |new_file|
        self.check_element_for_nodes(new_file, ['user', 'url', 'thumbnail', 'item', 'id']);
      end if !self.check_element_for_nodes(new_files, ['new-file'])
    end if !self.check_element_for_nodes(rexml_doc.root, ['new-files'])
  end
  def test_get_new_files_from_user_xml
    rexml_doc = @envato_api.get_new_files_from_user('collis', 'themeforest' 'xml');
    assert_nil(rexml_doc.root.elements['error'], 'API returned error response: Check your parameters');
    rexml_doc.root.each_element('//new-files-from-user') do |new_files_from_user|
      new_files_From_user
    end if !self.check_element_for_nodes(rexml_doc.root, ['new-files-from-user'])
  end
end