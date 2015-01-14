#filename: super_user_spec.rb

#this is to test the arm functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Super User, Arms", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Super User, Arms", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
  end

#tests

  #Testing creating an arm
  it "- create an arm" do
    click_on 'New'
    expect(page).to have_content 'New Arm'
    fill_in 'arm_title', :with => 'Test Arm'
    click_on 'Create'
    expect(page).to have_content 'Arm was successfully created.'
  end

  #Testing updating an arm
  it "- update an arm" do
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Edit'
    expect(page).to have_content 'Editing Arm'
    fill_in 'arm_title', :with => 'Updated Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'
    expect(page).to have_content 'Title: Updated Arm 1'
    click_on 'Edit'
    expect(page).to have_content 'Editing Arm'
    fill_in 'arm_title', :with => 'Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'
    expect(page).to have_content 'Title: Arm 1'
  end

  #Testing destroying an arm
  it "- destroys an arm" do
    click_on 'Test Arm'
    expect(page).to have_content 'Title: Test Arm'
    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Arm was successfully destroyed.'
    expect(page).to_not have_content 'Test Arm'
  end

  #Testing creating a super user
  it "- create a super user" do
    click_on 'New'
    fill_in 'user_email', :with => 'superuser@test.com'
    check 'user_is_admin'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'
    expect(page).to have_content 'Super User: Yes'
    expect(page).to have_content 'Email: superuser@test.com'
  end

  #Testing updating a super user
  it "- update a super user" do
    click_on 'superuser@test.com'
    expect(page).to have_content 'Email: superuser@test.com'
    click_on 'Edit'
    expect(page).to have_content 'Editing User'
    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'
    expect(page).to have_content 'Super User: Yes'
    expect(page).to have_content 'Email: superuser@test.com'
    expect(page).to have_content 'Roles: Clinician'
    click_on 'Edit'
    expect(page).to have_content 'Editing User'
    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'
    expect(page).to have_content 'Super User: Yes'
    expect(page).to have_content 'Email: superuser@test.com'
    expect(page).to_not have_content 'Roles: Clinician'
  end

  #Testing detroying a super user
  it "- destroy a super user" do
    click_on 'superuser@test.com'
    expect(page).to have_content 'Email: superuser@test.com'
    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'
    expect(page).to_not have_content 'superuser@test.com'
  end
end