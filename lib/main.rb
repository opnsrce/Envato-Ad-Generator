require 'net/http';
require 'uri';
require 'rexml/document';
require 'RMagick';
require 'json';
require 'envato_api';
require 'envato_ad_generator';


api = EnvatoAPI.new
thumbnails = Array.new
popular_items = api.get_popular_items_last_week('graphicriver', 'xml');
REXML::XPath.match(popular_items, '//thumbnail').each do |thumbnail|
   thumbnails << thumbnail.text;
end
ad_generator = EnvatoAdGenerator.new(thumbnails);
ad = ad_generator.generate_ad(2, 2);
ad.write('ad.jpg');