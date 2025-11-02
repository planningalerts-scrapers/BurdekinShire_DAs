#!/usr/bin/env ruby
require 'scraperwiki'
require 'mechanize'

base_url = "https://www.burdekin.qld.gov.au/Planning-building-and-development/Planning-and-Development/Development-applications/Current-development-applications"

agent = Mechanize.new
main_page = agent.get(base_url)
date_scraped = Date.today.to_s
comment_url = "https://www.burdekin.qld.gov.au/About-council/Contact-us"

# Get applications from the last two weeks
start_date = (Date.today - 14).strftime("%d/%m/%Y")
end_date = Date.today.strftime("%d/%m/%Y")

total_records_saved = 0

url = "#{base_url}"
puts "Fetching page: #{url}"
page = agent.get(url)

if page.body.size < 1024
  puts "Page was only #{page.body.size} bytes - too small to have useful content!"
end

# Find all table rows in the results table (skip header row)
appls = page.search('.da-list-container article a')

puts "  found #{appls.size} applications on page"

appls.each do |appl|
  href = appl['href']

  application_link = nil

  if href
    application_link = page.link_with(href: href)
    next unless application_link
  end

  application_page = application_link.click

  fields = application_page.search('.development-application-details-list li')

  # Create the record
  record = {
    "council_reference" => '',
    "date_received" => '',
    "address" => application_page.at('h1.oc-page-title').text.strip,
    "description" => '',
    "status" => '',
    "info_url" => application_link.href,
    "comment_url" => comment_url,
    "date_scraped" => Date.today.to_s
  }

  fields.each do |field|
    label = field.at('.field-label').text.strip
    value = field.at('.field-value').text.strip

    case label
    when 'Application number'
      record['council_reference'] = value
    when 'proposal'
      record['description'] = value
    when 'Status'
      record['status'] = value
    when 'Lodgement date'
      time_obj = DateTime.parse(value)
      record['date_received'] = time_obj.strftime('%Y-%m-%d')
    end 
  end

  ScraperWiki.save_sqlite(['council_reference'], record)
  total_records_saved += 1
end

puts "Scraping complete. Total records saved: #{total_records_saved}"
puts "No applications found in date range!" if total_records_saved == 0
