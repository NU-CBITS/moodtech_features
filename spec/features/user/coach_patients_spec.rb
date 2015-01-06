#filename: coach_patients_spec.rb

#this is to test the users functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Coach, Patients", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Coach, Patients", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests
  #Testing view patient dashboard
  it "- view patients dashboard" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Patients'
    expect(page).to have_content 'Patient Dashboard'
    page.find("#patients")[:class].include?("table table hover")
  end

  #Testing specific patient report
  it "- view patient report" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Patients'
    expect(page).to have_content 'Patient Dashboard'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[2]/td[1]/a').click
    expect(page).to have_content 'Patient Mood Ratings and PHQ9 Assessment Scores'
  end

  #Testing managing PHQ9 in patient report
  it "- managing PHQ9" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Patients'
    expect(page).to have_content 'Patient Dashboard'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[2]/td[1]/a').click
    expect(page).to have_content 'Patient Mood Ratings and PHQ9 Assessment Scores'
    click_on 'Manage'
    expect(page).to have_content 'PHQ assessments for '
    click_on 'New Phq assessment'
    expect(page).to have_content 'New PHQ assessment for '
    fill_in 'phq_assessment_q1', :with => '2'
    fill_in 'phq_assessment_q2', :with => '2'
    fill_in 'phq_assessment_q3', :with => '2'
    fill_in 'phq_assessment_q4', :with => '2'
    fill_in 'phq_assessment_q5', :with => '2'
    fill_in 'phq_assessment_q6', :with => '2'
    fill_in 'phq_assessment_q7', :with => '2'
    fill_in 'phq_assessment_q8', :with => '2'
    fill_in 'phq_assessment_q9', :with => '2'
    click_on 'Create Phq assessment'
    expect(page).to have_content 'Phq assessment was successfully created.'
    click_on 'Delete'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Phq assessment was successfully destroyed.'
    click_on 'Patient dashboard'
    expect(page).to have_content 'Patient Mood Ratings and PHQ9 Assessment Scores'
  end

  #Testing viewing activities viz in patient report
  it "- view activities viz" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Patients'
    expect(page).to have_content 'Patient Dashboard'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[2]/td[1]/a').click
    expect(page).to have_content 'Patient Mood Ratings and PHQ9 Assessment Scores'
    click_on 'Activities visualization'
    expect(page).to have_content 'Activities Overview'
    page.find("#nav_main li:nth-child(2) a").click
    expect(page).to have_content '3 day view'
    page.find("#nav_main li:nth-child(3) a").click
    expect(page).to have_content 'Average Pleasure Discrepency:'
    page.find("#nav_main li:nth-child(1) a").click
    within '#summary' do
      expect(page).to have_content 'Most Recent Activities'
    end
  end

  #Testing viewing thoughts viz in patient report
  it "- view thoughts viz" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Patients'
    expect(page).to have_content 'Patient Dashboard'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[2]/td[1]/a').click
    expect(page).to have_content 'Patient Mood Ratings and PHQ9 Assessment Scores'
    click_on 'Thoughts visualization'
    page.find("#ThoughtVizContainer")
  end
end