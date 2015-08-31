# filename: super_user_spec.rb

describe 'Super User signs in,', type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_user(ENV['User_Email'], 'TFD Moderator',
                   ENV['User_Password'])
    end

    before do
      visit "#{ENV['Base_URL']}/think_feel_do_dashboard"
    end

  else
    before do
      sign_in_user(ENV['User_Email'], 'TFD Moderator',
                   ENV['User_Password'])
    end
  end

  it 'creates an arm' do
    click_on 'Arms'
    click_on 'New'
    fill_in 'arm_title', with: 'Test Arm'
    click_on 'Create'
    expect(page).to have_content 'Arm was successfully created.'
  end

  it 'updates an arm' do
    click_on 'Arms'
    click_on 'Arm 1'
    click_on 'Edit'
    fill_in 'arm_title', with: 'Updated Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'

    expect(page).to have_content 'Title: Updated Arm 1'

    click_on 'Edit'
    fill_in 'arm_title', with: 'Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'

    expect(page).to have_content 'Title: Arm 1'
  end

  it 'sees appropriate alert when trying to destroy an arm' do
    click_on 'Arms'
    click_on 'Test Arm'
    expect(page).to have_content 'Title: Test Arm'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'You do not have privileges to delete an ' \
                                 'arm. Please contact the site administrator ' \
                                 'to remove this arm.'
  end

  it 'creates a super user' do
    click_on 'Users'
    click_on 'New'
    fill_in 'user_email', with: 'superuser@test.com'
    check 'user_is_admin'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content "Super User: Yes\nEmail: superuser@test.com"
  end

  it 'updates a super user' do
    click_on 'Users'
    click_on 'superuser@test.com'
    click_on 'Edit'
    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content "Super User: Yes\nEmail: superuser@test.com" \
                                 "\nRoles: Clinician"

    click_on 'Edit'
    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to_not have_content 'Roles: Clinician'
  end

  it 'destroys a super user' do
    click_on 'Users'
    click_on 'superuser@test.com'
    expect(page).to have_content 'Email: superuser@test.com'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'superuser@test.com'

    sign_out('TFD Moderator')
  end
end
