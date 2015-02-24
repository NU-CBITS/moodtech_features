# filename: researcher_reports_spec.rb

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers
require 'uuid'
require 'fileutils'
require_relative '../../../spec/configure_cloud'

def setup
  @download_dir = File.join(Dir.pwd, UUID.new.generate)
  FileUtils.mkdir_p @download_dir

  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = @download_dir
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'images/jpeg, application/pdf'
  profile['pdfjs.disabled'] = true
  @driver = Selenium::WebDriver.for :firefox, profile: profile
end

def teardown
  @driver.quit
  FileUtils.rm_rf @download_dir
end

def run
  setup
  yield
  teardown
end

run do
  @driver.get ENV['Base_URL'] + '/users/sign_in'
  @driver.find_element(id: 'user_email').send_keys(ENV['Researcher_Email'])
  @driver.find_element(id: 'user_password').send_keys(ENV['Researcher_Password'])
  @driver.find_element(css: '.btn.btn-default').submit

  @driver.get ENV['Base_URL'] + '/think_feel_do_dashboard/reports'
  download_link = @driver.find_elements(class: 'list-group-item')[0]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[1]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[2]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[3]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[4]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[5]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[6]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[7]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[8]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[9]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[10]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[11]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[12]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[13]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[14]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[15]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[16]
  download_link.click

  download_link = @driver.find_elements(class: 'list-group-item')[17]
  download_link.click

  files = Dir.glob('#{@download_dir}/**')
  expect(files.count).to eql 18

  sorted_files = files.sort_by { |file| File.mtime(file) }
  expect(File.size(sorted_files.last)).to be > 0
end
