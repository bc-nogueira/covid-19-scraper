require 'nokogiri'
require 'httparty'
require 'byebug'
require 'awesome_print'
require 'watir'
require 'webdrivers'
require 'headless'

def execute
  puts 'What site do you want to scrap? (enter the number)'
  puts '1 - nCoV2019.live'
  puts '2 - Bing COVID'
  option = gets.chomp

  if %w[1 2].include? option
    puts 'Executing'
    option == '1' ? ncov_live_scraper : bing_scraper
    puts 'Finished!'
  else
    puts 'Invalid option'
  end
end

def ncov_live_scraper
  url = 'https://ncov2019.live'
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  info_per_country = []

  table = parsed_page.css('table#sortable_table_Global')

  table.css('tr').each do |line|
    next if line.css('.text--gray').first.text.eql?('Region')

    info = []

    info.push(line.css('.text--gray').text)
    info.push('CONFIRMED')
    info.push(line.css('.text--green').text)
    info.push('DECEASED')
    info.push(line.css('.text--red').text)
    info.push('RECOVERED')
    info.push(line.css('.text--blue').text)
    info.push('SERIOUS')
    info.push(line.css('.text--yellow').text)

    info_per_country.push(info)
  end
end

def bing_scraper
  url = 'https://www.bing.com/covid'

  info_per_country = []

  Headless.ly do
    browser = Watir::Browser.new
    browser.goto url

    info_tile_content = browser.div(css: '.infoTile').text.split("\n")
    global_info = []
    global_info.push('GLOBAL')
    global_info.push('TOTAL')
    global_info.push(info_tile_content[1])
    global_info.push('ATIVOS')
    global_info.push(info_tile_content[3])
    global_info.push('RECUPERADOS')
    global_info.push(info_tile_content[5])
    global_info.push('FATAIS')
    global_info.push(info_tile_content[7])

    info_per_country.push(global_info)

    browser.div(css: '.areas').divs.each do |area|
      next unless area.text.include?("\n")

      info = []
      country = area.text.split("\n").first
      info.push(country)
      area.click
      info_tile_content = browser.div(css: '.region.tab').div(css: '.infoTile').text.split("\n")
      info.push('TOTAL')
      info.push(info_tile_content[1])
      info.push('ATIVOS')
      info.push(info_tile_content[3])
      info.push('RECUPERADOS')
      info.push(info_tile_content[5])
      info.push('FATAIS')
      info.push(info_tile_content[7])

      info_per_country.push(info)
    end
  end
end

execute
