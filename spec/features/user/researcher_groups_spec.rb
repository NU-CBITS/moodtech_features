# filename: researcher_groups_spec.rb

describe 'Researcher signs in, navigates to Groups,',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_user(ENV['Researcher_Email'], 'TFD Moderator',
                   ENV['Researcher_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_user(ENV['Researcher_Email'], 'TFD Moderator',
                   ENV['Researcher_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/groups"
  end

  it 'creates a group' do
    click_on 'New'
    fill_in 'group_title', with: 'Testing Group'
    select 'Arm 1', from: 'group_arm_id'
    select ENV['User_Email'], from: 'group_moderator_id'
    click_on 'Create'
    expect(page).to have_content 'Group was successfully created.'
  end

  it 'updates a group' do
    click_on 'Group 1'
    click_on 'Edit'
    fill_in 'group_title', with: 'Updated Group 1'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content 'Title: Updated Group 1'

    click_on 'Edit'
    fill_in 'group_title', with: 'Group 1'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content 'Title: Group 1'
  end

  it 'updates moderator for Group 1' do
    find('h1', text: 'Groups')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Group 1'
    click_on 'Edit'
    select ENV['User_Email'], from: 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content "Coach/Moderator: #{ENV['User_Email']}"

    click_on 'Edit'
    select ENV['Clinician_Email'], from: 'group_moderator_id'
    click_on 'Update'
    expect(page).to have_content 'Group was successfully updated.'

    expect(page).to have_content "Coach/Moderator: #{ENV['Clinician_Email']}"
  end

  it 'destroys a group' do
    find('h1', text: 'Groups')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Testing Group'
    expect(page).to have_content 'Title: Testing Group'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'Group was successfully destroyed.'

    expect(page).to_not have_content 'Testing Group'
  end

  it 'manages tasks within a group' do
    find('h1', text: 'Groups')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Group 1'
    click_on 'Manage Tasks'
    select 'LEARN: Do - Planning Slideshow 3 of 4',
           from: 'task_bit_core_content_module_id'
    fill_in 'task_release_day', with: '1'
    click_on 'Assign'
    expect(page).to have_content 'Task assigned.'

    page.execute_script('window.scrollTo(0,5000)')
    within('tr', text: 'LEARN: Do - Planning Slideshow 3 of 4') do
      page.driver.execute_script('window.confirm = function() {return true}')
      click_on 'Unassign'
    end

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
