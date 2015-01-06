#filename: researcher_groups_spec.rb

#this is to test the groups functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Researcher, Groups", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Research, Groups", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests

#Testing creating a group
  it "- create a group" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'New'
    expect(page).to have_content 'New Group'
    fill_in 'group_title', :with => 'Testing Group'
    select 'Arm 1', :from => 'group_arm_id'
    select ENV['User_Email'], :from => 'group_moderator_id'
    click_on 'Create'
    expect(page).to have_content 'Group was successfully created.'
  end

  #Testing updating a group
  it "- update a group" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Title: fake'
    click_on 'Edit'
    expect(page).to have_content 'Editing Group'
    fill_in 'group_title', :with => 'Updated fake'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'
    expect(page).to have_content 'Title: Updated fake'
    click_on 'Edit'
    expect(page).to have_content 'Editing Group'
    fill_in 'group_title', :with => 'fake'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'
    expect(page).to have_content 'Title: fake'
  end

  #Testing adding/removing a moderator from a group
  it "- update moderator" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fake'
    expect(page).to have_content 'Title: fake'
    click_on 'Edit'
    select ENV['Clinician_Email'], :from => 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'
    click_on 'Edit'
    select ENV['User_Email'], :from => 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'
  end

  #Testing destroying a group
  it "- destroy a group" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'Testing Group'
    expect(page).to have_content 'Title: Testing Group'
    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Group was successfully destroyed.'
    expect(page).to_not have_content 'Testing Group'
  end

  #Testing managing tasks
  it "- manage tasks within a group" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'CSV Reports'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    click_on 'fun'
    expect(page).to have_content 'Title: fun'
    click_on 'Manage Tasks'
    expect(page).to have_content 'Recurring termination day (if applicable)'
    select 'DO: #1 Awareness', :from => 'task_bit_core_content_module_id'
    fill_in 'task_release_day', :with => '1'
    click_on 'Assign'
    expect(page).to have_content 'Task assigned.'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[2]/td[6]/a').click
    page.accept_alert 'Are you sure?'
    within '#tasks' do
      expect(page).to_not have_content 'DO: #1 Awareness'
    end
  end
end