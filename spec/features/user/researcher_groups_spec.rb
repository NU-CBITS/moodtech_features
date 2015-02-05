# filename: researcher_groups_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Researcher, Groups', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Researcher_Email']
      fill_in 'user_password', with: ENV['Researcher_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content 'CSV Reports'

    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
  end

  # tests
  # Testing creating a group
  it '- create a group' do
    click_on 'New'
    expect(page).to have_content 'New Group'

    fill_in 'group_title', with: 'Testing Group'
    select 'Arm 1', from: 'group_arm_id'
    select ENV['User_Email'], from: 'group_moderator_id'
    click_on 'Create'
    expect(page).to have_content 'Group was successfully created.'
  end

  # Testing updating a group
  it '- update a group' do
    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Edit'
    expect(page).to have_content 'Editing Group'

    fill_in 'group_title', with: 'Updated Group 1'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content 'Title: Updated Group 1'

    click_on 'Edit'
    expect(page).to have_content 'Editing Group'

    fill_in 'group_title', with: 'Group 1'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content 'Title: Group 1'
  end

  # Testing adding/removing a moderator from a group
  it '- update moderator' do
    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Edit'
    select ENV['Clinician_Email'], from: 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    click_on 'Edit'
    select ENV['User_Email'], from: 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'
  end

  # Testing destroying a group
  it '- destroy a group' do
    click_on 'Testing Group'
    expect(page).to have_content 'Title: Testing Group'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Group was successfully destroyed.'

    expect(page).to_not have_content 'Testing Group'
  end

  # Testing managing tasks
  it '- manage tasks within a group' do
    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Manage Tasks'
    expect(page).to have_content 'Recurring termination day (if applicable)'

    select 'LEARN: Do - Planning Slideshow 3 of 4', from: 'task_bit_core_content_module_id'
    fill_in 'task_release_day', with: '1'
    click_on 'Assign'
    expect(page).to have_content 'Task assigned.'

    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[23]/td[6]/a').click
    page.accept_alert 'Are you sure?'
    within '#tasks' do
      expect(page).to_not have_content 'LEARN: Do - Planning Slideshow 3 of 4'
    end
  end
end
