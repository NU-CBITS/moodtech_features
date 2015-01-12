#filename: nudge_spec.rb

#this file is to test the messaging functionality

require_relative '../../../../spec/spec_helper'
require_relative '../../../../spec/configure_cloud'

#to run locally comment this block out
# describe "Nudges", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Participant_Email']
#       fill_in 'participant_password', :with => ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     expect(page).to have_content "What's on your mind?"
#   end

#to run on Sauce Labs comment this block out
describe "Nudges", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content "What's on your mind?"
  end

#tests
  it "- nudge another participant" do
    visit ENV['Base_URL'] + '/social_networking/profile_page/596136196'
    click_on 'Nudge'
    expect(page).to have_content 'Nudge sent!'
    visit ENV['Base_URL']
    expect(page).to have_content 'nudged profile question participant'
  end

  it "- receive a nudge alert on profile page" do
    visit ENV['Base_URL'] + '/social_networking/profile_page'
    if page.has_css?('.modal-content')
      within('.modal-content') do
        expect(page).to have_content 'Start creating'
        find(:xpath, '//*[@id="profile-icon-selection"]/div[2]/div/div[2]/div[1]/div[3]').click
      end
      expect(page).to have_css '.alert.alert-info'
      expect(page).to have_content 'clinician1@example.com nudged you!'
    else
      expect(page).to have_css '.alert.alert-info'
      expect(page).to have_content 'clinician1@example.com nudged you!'
    end
  end

  it "- expect to see nudge on landing page" do
    expect(page).to have_content 'nudged participant1'
  end
end
