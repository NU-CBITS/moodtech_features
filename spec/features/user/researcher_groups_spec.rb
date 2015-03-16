# filename: researcher_groups_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Researcher signs in and navigates to Groups',
         type: :feature, sauce: sauce_labs do
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
    find('h1', text: 'Groups')
  end

  it 'creates a group' do
    click_on 'New'
    expect(page).to have_content 'New Group'

    fill_in 'group_title', with: 'Testing Group'
    select 'Arm 1', from: 'group_arm_id'
    select ENV['User_Email'], from: 'group_moderator_id'
    click_on 'Create'
    expect(page).to have_content 'Group was successfully created.'
  end

  it 'updates a group' do
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

  it 'updates moderator for Group 1' do
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

  it 'destroys a group' do
    click_on 'Testing Group'
    expect(page).to have_content 'Title: Testing Group'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Group was successfully destroyed.'

    expect(page).to_not have_content 'Testing Group'
  end

  it 'manages tasks within a group' do
    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Manage Tasks'
    expect(page).to have_content 'Termination day (if applicable)'

    select 'LEARN: Do - Planning Slideshow 3 of 4',
           from: 'task_bit_core_content_module_id'
    fill_in 'task_release_day', with: '1'
    click_on 'Assign'
    expect(page).to have_content 'Task assigned.'

    within('tr', text: 'LEARN: Do - Planning Slideshow 3 of 4') do
      click_on 'Unassign'
    end

    page.accept_alert 'Are you sure?'
    within '#tasks' do
      expect(page).to_not have_content 'LEARN: Do - Planning Slideshow 3 of 4'
    end
  end

  it 'uses breadcrumbs to return to home' do
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
