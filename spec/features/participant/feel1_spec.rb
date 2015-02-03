#filename: feel1_spec.rb

#this file is to test the functionality of using the FEEL to

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this block out
# describe "Feel", type: :feature, sauce: true do
#   before(:each) do
#     visit ENV['Base_URL'] + '/participants/sign_in'
#     within('#new_participant') do
#       fill_in 'participant_email', with: ENV['Participant_Email']
#       fill_in 'participant_password', with: ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/FEEL'
#     expect(page).to have_content 'Tracking Your Mood & Emotions'
#   end

#to run on Sauce Labs comment this block out
describe "Feel", type: :feature, sauce: false do
  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/FEEL'
    expect(page).to have_content 'Tracking Your Mood'
  end

#tests

#Testing Tracking Your Mood and Emotions in the FEEL to
  it "- tracking your mood" do
    click_on 'Tracking Your Mood'
    expect(page).to have_content 'Rate your Mood'
    select '6', from: 'mood[rating]'
    click_on 'Continue'
    expect(page).to have_content 'Mood saved'
    expect(page).to have_content 'Positive and Negative Emotions'
    click_on 'Continue'
    expect(page).to have_content 'Feeling Tracker Landing'
  end
end