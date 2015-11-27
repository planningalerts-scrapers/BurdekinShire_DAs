#!/usr/bin/env ruby
require 'scraperwiki'
require 'mechanize'

base_url = "http://www.burdekin.qld.gov.au/building-planning-and-infrastructure/town-planning/current-development-applications/"

agent = Mechanize.new
main_page = agent.get(base_url)
date_scraped = Date.today.to_s
comment_url = "http://www.burdekin.qld.gov.au/council/contact-council/online-contact-form/"

def remove_at(str)
  if(str.end_with?("at "))
    return str[0..(str.length-5)]
  else
    return str
  end
end

def extract_address_and_description(str)
  #find first number, and trim untill - or \n
  address = str[/[0-9](.*)/, 0]
  description = remove_at(str.gsub(address,"").chomp)
  [address,description]
end

main_page.links.each do |link|
  if( link.text["CONS"] )
    address_description = extract_address_and_description(link.attributes.parent.children[3].text)
	record = {
		'council_reference' => link.text[0, 11], # multiple notices can have the same ref...
		'address' => address_description[0],
		'description' => address_description[1],
		'info_url' => link.href,
		'comment_url' => comment_url,
		'date_scraped' => date_scraped
	}
#	puts "   record:"
#	puts "   #{record}"
	if (ScraperWiki.select("* from data where `council_reference` LIKE '#{record['council_reference']}'").empty? rescue true)
	  ScraperWiki.save_sqlite(['council_reference'], record)
      puts "Storing: #{record['council_reference']}"
	else
	  puts "Skipping already saved record " + record['council_reference']
	end
  end  
  
end



