# Introduction

Welcome to the Burdekin, sugar capital of Australia and one of the most prosperous rural communities in the country.
It's also one of the prettiest districts along the Queensland coast and boasts a stable population of warm,
friendly and down-to-earth residents.

It scrapes data from:
https://www.burdekin.qld.gov.au/Planning-building-and-development/Planning-and-Development/Development-applications/Current-development-applications

# Install

    bundle install

## To run the scraper

    bundle exec ruby scraper.rb

You can, but don't need to, set `MORPH_AUSTRALIAN_PROXY` to the url for an Australian proxy

Set `MORPH_DEBUG` to '1' to see debug output

### Expected output

    Fetching page: https://www.burdekin.qld.gov.au/Planning-building-and-development/Planning-and-Development/Development-applications/Current-development-applications
    found 23 applications on page
    Storing MCU25/0014 - Mitchell Road, Clare QLD 4807: Decided
    
    Storing RAL25/0019 - 151 and 157 Burstall Road Airdmillan: In Progress
    
    (etc)
    
    Storing MCU23/0003 - 8-16 Eighth Avenue Home Hill: Decided
    
    Storing MCU25/0013 - 94 Macmillan Street, Ayr QLD 4807: Decided
    
    Scraping complete. Total records saved: 23
    
    Execution time ~ 10 seconds.

## To run style and coding checks

    bundle exec rubocop

## To check for security updates

    gem install bundler-audit
    bundle-audit
