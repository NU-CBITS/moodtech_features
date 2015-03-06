# filename: spec_helper.rb

require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium-webdriver'
require 'sauce'
require 'sauce/capybara'
require 'sauce_whisk'
require 'byebug'

# RSpec configuration options
RSpec.configure do |config|
  config.full_backtrace = false
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.profile_examples = 10
end

# define methods for setting the driver
def sauce_labs
  ENV['Sauce'] || false
end

def test_driver
  puts "Sauce Labs is set to #{sauce_labs}"
  if sauce_labs == false
    :selenium
  else
    :sauce
  end
end

def screen_shot
  if sauce_labs == true
    false
  else
    true
  end
end

# Capybara configuration options
Capybara.default_wait_time = 30
Capybara.default_driver = test_driver
Capybara::Screenshot.register_driver(:sauce) do |driver, path|
  driver.render(path)
end
Capybara::Screenshot.autosave_on_failure = screen_shot
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//, '')}"
end
Capybara.save_and_open_page_path = 'screenshots/'
Capybara::Screenshot.prune_strategy = :keep_last_run

# Sauce configuration options
Sauce.config do |config|
  config[:job_name] = "MoodTech-Staging #{ Time.now.strftime('%-m/%-d/%Y') }"
  config[:start_tunnel] = false
  config[:browsers] = [
    ['Windows XP', 'Firefox', '32'],
    ['Windows XP', 'Chrome', '37'],
    ['Windows 7', 'Firefox', '32'],
    ['Windows 7', 'Chrome', '37'],
    ['OS X 10.6', 'Firefox', '32'],
    ['OS X 10.6', 'Chrome', '37'],
    ['OS X 10.6', 'Chrome', '37'],
    ['OS X 10.9', 'Firefox', '32'],
    ['OS X 10.9', 'Chrome', '37'],
    ['OS X 10.10', 'Firefox', '32'],
    ['OS X 10.10', 'Chrome', '37']
  ].shuffle[0]

  config.after do |example|
    if example.exception.nil?
      SauceWhisk::Jobs.pass_job @driver.session_id
    else
      SauceWhisk::Jobs.fail_job @driver.session_id
    end
    @driver.quit
  end
end
