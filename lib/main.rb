require 'envato_api';
require 'ad_generator';


api = EnvatoAPI.new
thumbnails = Array.new
popular_items = api.get_popular_items('graphicriver', 'xml');
REXML::XPath.match(popular_items, '//thumbnail').each do |thumbnail|
    thumbnails << thumbnail.text;
end

ad_generator = AdGenerator.new(thumbnails);
ad = ad_generator.generate_ad(5, 5);
ad.write('ad.jpg');
