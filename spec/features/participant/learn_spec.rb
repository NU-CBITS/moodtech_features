#filename: learn_spec.rb

#this file is to test the functionality of logging in, selecting the "LEARN" section,
# and reading through the first lesson "Think, Feel, Do Your Way Out of Depression"

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this block out
# describe "Learn", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Participant_Email']
#       fill_in 'participant_password', :with => ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/LEARN'
#     expect(page).to have_content 'You have read'
#   end

#to run on Sauce Labs comment this block out
describe "Learn", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/LEARN'
    expect(page).to have_content 'You have read'
  end

#tests
  it "- read Lesson 1" do
    expect(page).to have_content 'You have read 0 lessons out of 1.'
    click_on 'Do - Awareness Introduction'
    expect(page).to have_content 'This is just the beginning...'
    click_on 'Continue'
    expect(page).to have_content 'You have read 1 lesson out of 1.'
  end
end