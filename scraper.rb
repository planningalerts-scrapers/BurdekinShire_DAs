# #!/usr/bin/env ruby
# require 'scraperwiki'
# require 'mechanize'
#
# base_url = "http://www.burdekin.qld.gov.au/building-planning-and-infrastructure/town-planning/current-development-applications/"
#
# agent = Mechanize.new
# main_page = agent.get(base_url)
# date_scraped = Date.today.to_s
# comment_url = "http://www.burdekin.qld.gov.au/council/contact-council/online-contact-form/"
#
# def extract_address_and_description(str)
# # delimit the address and description with " at "
#   str.split(" at ")
# end
#
# main_page.links.each do |link|
#   if( link.text["CONS"] )
#     description_address = extract_address_and_description(link.attributes.parent.children[3].text)
# 	record = {
# 		'council_reference' => link.text[0, 11], # multiple notices can have the same ref...
# 		'address' => "#{description_address[1]}, QLD",
# 		'description' => description_address[0],
# 		'info_url' => link.href,
# 		'comment_url' => comment_url,
# 		'date_scraped' => date_scraped
# 	}
#   ScraperWiki.save_sqlite(['council_reference'], record)
#   puts "Storing: #{record['council_reference']}"
#   end
#
# end

puts "Scraper is broken and the new council page doesn't have addresses on it!"
puts "See https://github.com/planningalerts-scrapers/issues/issues/87"
