# COVID-19 Ruby Scraper

This is a simple scraper made with Ruby. It was made for study purposes and as practice to be used in a future project.

It's possible to scrap from two different websites:
* Bing Covid (uses Nokogiri gem)
* nCoV2019.live (needs to use Watir gem because the website uses React components)

## How to run it

1. Clone this repository
2. Enter the directory
3. Run `bundle install` to install dependencies
4. Run it with `ruby scraper.rb` 

### Observation

For now this scrapper doesn't do anything to the data, it only saves into an array.