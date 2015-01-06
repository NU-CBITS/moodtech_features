#filename: participant_bugs_spec.rb

#this file is to test bug fixes

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Participant Bugs", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Participant Bugs", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests

#Testing bug that redirects participant to user login upon completion of the replay introduction feature
  it "- redirect error at completion of Replay Intro " do
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'SUPPORT'
    click_on 'SUPPORT Home'
    expect(page).to have_content 'Frequently Asked Questions'
    click_on 'Replay Intro'
    expect(page).to have_content 'Welcome to ThinkFeelDo'
    click_on 'Continue'
    expect(page).to have_content 'How to Maximize Your Benefit from ThinkFeelDo'
    click_on 'Continue'
    expect(page).to have_content 'What Should I Do When I Log in?'
    click_on 'Continue'
    expect(page).to have_content "How Do I Know What's New on the Site?"
    click_on 'Continue'
    expect(page).to have_content 'What Should I Expect?'
    click_on 'Continue'
    expect(page).to have_content 'What Might Get in the Way?'
    click_on 'Continue'
    expect(page).to have_content 'Get Started'
    click_on 'Continue'
    expect(page).to have_content 'Additional Resources'
  end
end