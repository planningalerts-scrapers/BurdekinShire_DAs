#!/usr/bin/env ruby
# frozen_string_literal: true

require "scraperwiki"
require "mechanize"

base_url = "https://www.burdekin.qld.gov.au/Planning-building-and-development/Planning-and-Development/Development-applications/Current-development-applications"

agent = Mechanize.new

# Not currently needed
if ENV["MORPH_AUSTRALIAN_PROXY"]
  # On morph.io set the environment variable MORPH_AUSTRALIAN_PROXY to
  # http://morph:password@au.proxy.oaf.org.au:8888 replacing a password with
  # the real password.
  puts "Using Australian proxy..."
  agent.agent.set_proxy(ENV["MORPH_AUSTRALIAN_PROXY"])
end

_main_page_with_cookies = agent.get(base_url)
date_scraped = Date.today.to_s
comment_url = "https://www.burdekin.qld.gov.au/About-council/Contact-us"

total_records_saved = 0

url = base_url.to_s
puts "Fetching page: #{url}"
page = agent.get(url)

puts "Page was only #{page.body.size} bytes - too small to have useful content!" if page.body.size < 1024

# Find all table rows in the result table (skip header row)
applications = page.search(".da-list-container article a")

puts "  found #{applications.size} applications on page"

applications.each do |application|
  # Convert from Nokogiri Element to Mechanize::Page::Link
  application_link = Mechanize::Page::Link.new(application, agent, page)

  application_page = application_link.click

  fields = application_page.search(".development-application-details-list li")

  # Create the record
  record = {
    "council_reference" => "",
    "date_received" => "",
    "address" => application_page.at("h1.oc-page-title").text.strip,
    "description" => "",
    "status" => "",
    "info_url" => application_link.href,
    "comment_url" => comment_url,
    "date_scraped" => date_scraped,
  }

  fields.each do |field|
    label = field.at(".field-label").text.strip
    value = field.at(".field-value").text.strip

    case label
    when "Application number"
      record["council_reference"] = value
    when "Proposal"
      record["description"] = value
    when "Status"
      record["status"] = value
    when "Lodgement date"
      time_obj = DateTime.parse(value)
      record["date_received"] = time_obj.strftime("%Y-%m-%d")
    when "Category", "Applicant name", "Decision", "Decision date"
      puts "info: Ignoring unused field: #{label.inspect}: #{value.inspect}" if ENV["MORPH_DEBUG"]
    else
      warn "WARNING: Unexpected field: #{label.inspect}: #{value.inspect}" if ENV["MORPH_DEBUG"]
    end
  end
  puts "RECORD: #{record.to_yaml}" if ENV["MORPH_DEBUG"]
  puts "Storing #{record['council_reference']} - #{record['address']}: #{record['status']}"
  puts
  ScraperWiki.save_sqlite(["council_reference"], record)
  total_records_saved += 1
end

puts "Scraping complete. Total records saved: #{total_records_saved}"
warn "WARNING: No applications found in date range!" if total_records_saved.zero?
