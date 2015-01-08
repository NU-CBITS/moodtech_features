#filename: do2_spec.rb

#this file is to test the functionality of using the DO tool

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Do", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Alt_Participant_Email']
#       fill_in 'participant_password', :with => ENV['Alt_Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/DO'
#     expect(page).to have_content 'Add a New Activity'
#   end

#to run on Sauce Labs comment this block out
describe "Do", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Alt_Participant_Email']
      fill_in 'participant_password', :with => ENV['Alt_Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Your Activities'
  end

#define methods for this spec file
  def choose_rating(element_id, value)
    find("##{ element_id } select").find(:xpath, "option[#{(value + 1)}]").select_option
  end

#tests

#Testing the #1 Awareness portion of the DO tool
  it "- awareness with already entered but not completed awake period" do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Continue'
    expect(page).to have_content "OK, let's talk about yesterday."
    expect(page).to have_content 'Last Recorded Awake Period:'
    click_on 'Complete'
    expect(page).to have_content 'Review Your Day'

    fill_in 'activity_type_0', :with => 'Get ready for work'
    choose_rating("pleasure_0", 6)
    choose_rating("accomplishment_0", 7)
    click_on 'Continue'
    page.accept_alert "Are you sure that you would like to make this activity public?"
    expect(page).to have_content 'Activity saved'
    expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'
    click_on 'Continue'
    expect(page).to have_content 'Things you found fun.'
    click_on 'Continue'
    expect(page).to have_content "Things that make you feel like you've accomplished something."
    click_on 'Continue'
    expect(page).to have_content 'Your Activities'
  end

  it "- visualization" do
    expect(page).to have_content 'Recent Past Activities'
    click_on 'Edit'
    expect(page).to have_content 'You said you were going to'
  end
end
