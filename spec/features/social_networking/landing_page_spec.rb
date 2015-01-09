#filename: landing_page_spec.rb

#this file is to test the messaging functionality

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Social Networking landing page", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Participant_Email']
#       fill_in 'participant_password', :with => ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
#     expect(page).to have_content 'Inbox'
#   end

#to run on Sauce Labs comment this block out
describe "Social Networking landing page", :type => :feature, :sauce => false do

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
  it '- create a profile' do
    click_on 'Create a Profile'
    within('.modal-content') do
      expect(page).to have_content 'Start creating'
      find(:xpath, '//*[@id="profile-icon-selection"]/div[2]/div/div[2]/div[1]/div[3]').click
    end
    fill_in 'new-answer-description-781294868', :with => 'Running'
    find(:xpath, '//*[@id="question-781294868"]/form/div[2]/button').click
    fill_in 'new-answer-description-932760744', :with => 'Blue'
    find(:xpath, '//*[@id="question-932760744"]/form/div[2]/button').click
    fill_in 'new-answer-description-10484799', :with => 'Mineral'
    find(:xpath, '//*[@id="question-10484799"]/form/div[2]/button').click
    fill_in 'new-answer-description-933797305', :with => 'Group 1'
    find(:xpath, '//*[@id="question-933797305"]/form/div[2]/button').click
    expect(page).to have_css '.fa.fa-pencil'
    visit ENV['Base_URL']
    expect(page).to have_content 'created a Profile: Welcome, participant1'
  end

  it '- create a whats on your mind post' do
    click_on "What's on your mind?"
    fill_in 'new-on-your-mind-description', :with => "I'm feeling happy!"
    click_on 'Save'
    expect(page).to have_content "said I'm feeling happy!"
  end

  it '- select link in TODO list' do
    click_on 'LEARN: Do - Awareness Introduction'
    expect(page).to have_content 'This is just the beginning...'
  end

  it '- view another participants profile' do
    find(:xpath, '//*[@id="main"]/div[2]/div/div/div/div[2]/div/div[1]/a/div').click
    expect(page).to have_content 'What is your favorite color?'
    expect(page).to have_content 'green'
  end

  it '- like a whats on your mind post written by another participant' do
    expect(page).to have_content "said it's always sunny in Philadelphia"
    find(:xpath, "//*[@id='SocialNetworking::OnTheMindStatement-576803333']/div[2]/button[1]").click
    expect(page).to have_css '.fa.fa-thumbs-up.fa-2x'
  end

  it '- comment on a nudge post' do
    expect(page).to have_content 'nudged participant1'
    find(:xpath, "//*[@id='SocialNetworking::Nudge-316146702']/div[2]/button[2]").click
    expect(page).to have_content 'What do you think?'
    fill_in 'comment-text', :with => 'Sweet Dude!'
    click_on 'Save'
    find(:xpath, ".//*[@id='SocialNetworking::Nudge-316146702']/div[2]/button[3]").click
    expect(page).to have_content ': Sweet Dude!'
  end

  it '- check for due date of a goal post' do
    expect(page).to have_content 'a Goal: p1 alpha'
    find(:xpath, "//*[@id='SocialNetworking::SharedItem-809335042']/div[2]/button[5]").click
    expect(page).to have_content 'due ' + Date.today.strftime('%b. %e, %Y') + ' at 12:00AM'
  end
end
