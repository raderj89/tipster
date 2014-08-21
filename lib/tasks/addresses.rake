require 'nokogiri'
require 'open-uri'

namespace :addresses do
  desc "scrape StreetEasy's HTML page of buildings"
  task populate: :environment do
    counter = 1
    while counter <= 295
      doc = Nokogiri::HTML(open("http://streeteasy.com/buildings/nyc/building_amenities:doorman?infinite_scrolling=false&page=#{counter}&view=details"))
      doc.css('div.left_two_thirds.items.item_rows.buildings div.item_inner').each do |div|
        begin
          image_path = open(div.search('div.photo a img')[0]['src'])
        rescue OpenURI::HTTPError
          image_path = nil
        rescue Errno::ENOENT
          image_path = nil
        end

        if div.search('div.building_address').text.blank?
          p = Property.create!(name: div.search('div.details_title h5 a').text.strip,
                           address: div.search('div.details_title h5 a').text.strip,
                           picture: (image_path unless image_path.nil?),
                           city: 'New York City',
                           state: 'NY',
                           zip: "10004")
          puts "PROCESSED: #{p.address}"
        else
          address = div.search('div.building_address').text.gsub(/(At\s)/, '')
          p = Property.create!(name: div.search('div.details_title h5 a').text.strip,
                           address: address.strip,
                           picture: (image_path unless image_path.nil?),
                           city: 'New York City',
                           state: 'NY',
                           zip: "10004")
          puts "PROCESSED: #{p.address}"
        end
      end
      counter += 1
    end
  end
end
