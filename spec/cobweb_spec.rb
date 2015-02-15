# Commented out for now as it is useless until I can get it to log in

# require 'capybara'
# require 'capybara/rspec'
# require 'selenium-webdriver'
# require 'cobweb'
# require 'redis'
# require_relative 'configure_cloud'

# describe 'cobweb', type: :feature do
#   it '- crawls without login' do
#     statistics = CobwebCrawler.new(cache: 600).crawl(ENV['Base_URL']) do |page|
#       puts "Just crawled #{page[:url]} and got a status of #{page[:status_code]}."
#     end.get_statistics
#     puts "Finished Crawl without login with #{statistics[:page_count]} pages and #{statistics[:asset_count]} assets."
#   end
# end
