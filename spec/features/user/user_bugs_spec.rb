#filename: user_bugs_spec.rb

#this is to test the users Arm 1 functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "User Dashboard Bugs", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "User Dashboard Bugs", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests
  #Testing bug where viewing a video slide in a lesson throws an error
  it "- viewing a video slide in a lesson" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 1'
    click_on 'Test video slide 1'
    expect(page).to have_content 'This slide was added for automated testing purposes'
  end

  #Testing bug where you receive error message when trying to edit a provider
  it "- editing a provider" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Content Modules'
    expect(page).to have_content 'Content Modules'
    if page.has_text?('Testing adding/updating slides/lessons')
      click_on 'Testing adding/updating slides/lessons'
      expect(page).to have_content 'New Provider'
      click_on 'slideshow provider'
      expect(page).to have_content 'Content Provider'
      expect(page).to have_content 'slideshow provider'
      click_on 'Edit'
      expect(page).to have_content 'Editing Content Provider'
    else
      find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/div[2]/div[2]/div/ul/li[3]').click
      if page.has_text?('Testing adding/updating slides/lessons')
        click_on 'Testing adding/updating slides/lessons'
        expect(page).to have_content 'New Provider'
        click_on 'slideshow provider'
        expect(page).to have_content 'Content Provider'
        expect(page).to have_content 'slideshow provider'
        click_on 'Edit'
        expect(page).to have_content 'Editing Content Provider'
      else
        find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/div[2]/div[2]/div/ul/li[4]').click
          click_on 'Testing adding/updating slides/lessons'
          expect(page).to have_content 'New Provider'
          click_on 'slideshow provider'
          expect(page).to have_content 'Content Provider'
          expect(page).to have_content 'slideshow provider'
          click_on 'Edit'
          expect(page).to have_content 'Editing Content Provider'
      end
    end
  end

  #Testing bug where you receive an error message when trying to access a specific group on Researcher Dashboard
  it "- error message when accesing a group" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fun'
    expect(page).to have_content 'Title: fun'
    click_on 'Edit'
    expect(page).to have_content 'Editing Group'
  end

  #Testing bug where you receive an error message when trying to access specific user on Researcher Dashboard
  it "- update a content author" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    click_on 'Users'
    expect(page).to have_content 'Listing Users'
    click_on ENV['Content_Author_Email']
    expect(page).to have_content 'Email: ' + ENV['Content_Author_Email']
  end

  #Testing bug where you receive an error message when creating a membership
  it "- create a group membership" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Participants'
    expect(page).to have_content 'Listing Participants'
    click_on 'fake'
    expect(page).to have_content 'Study Id: fake'
    click_on 'Assign New Group'
    expect(page).to have_content 'Assigning New Group to Participant'
    select 'fake', :from => 'membership_group_id'
    yesterday=Date.today.prev_day
    fill_in 'membership_start_date', :with => yesterday.strftime('%Y-%m-%d')
    today=Date.today
    next_year = today + 365
    fill_in 'membership_end_date', :with => next_year.strftime('%Y-%m-%d')
    click_on 'Assign'
    expect(page).to have_content 'Group was successfully assigned'
    expect(page).to have_content 'Study Id: fake'
    expect(page).to have_content 'Group: fake'
    expect(page).to have_content 'Membership Status: Active'
    find(:xpath, 'html/body/div[1]/div[3]/ul/a').click
    expect(page).to have_content 'Membership'
    expect(page).to have_content 'Start Date: ' + yesterday.strftime('%Y-%m-%d')
    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Group was successfully removed.'
  end

  #Testing bug where a clinician user cannot access their group
  it "- clinician authorization" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['Clinician_Email']
      fill_in 'user_password', :with => ENV['Clinician_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to_not have_content 'Users'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    expect(page).to_not have_content 'Manage Content'
    click_on 'fake'
    expect(page).to have_content 'Title: fake'
    expect(page).to have_content 'Patients'
    expect(page).to have_content 'Messaging'
    expect(page).to_not have_content 'Manage Tasks'
  end
end