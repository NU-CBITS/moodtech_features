#filename: goals_spec.rb

#this file is to test the messaging functionality

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Goals", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Participant_Email']
#       fill_in 'participant_password', :with => ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/social_networking/goal_tool'
#     expect(page).to have_content 'add a goal'
#   end

#to run on Sauce Labs comment this block out
describe "Goals", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/social_networking/goal_tool'
    expect(page).to have_content 'add a goal'
  end

#tests
  it "- create a goal" do
    click_on '+ add a goal'
    expect(page).to have_content 'What is your goal?'
    click_on 'Need some help writing a goal?'
    expect(page).to have_content 'This is where example goals and tips for write a goal will appear'
    fill_in 'new-goal-description', :with => 'eat a whole pizza'
    choose '8 weeks (end of study)'
    click_on 'Save'
    expect(page).to have_content '+ add a goal'
    expect(page).to have_content 'eat a whole pizza'
  end
end