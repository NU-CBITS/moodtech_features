# filename: super_user_spec.rb

describe 'Super User signs in,', type: :feature, sauce: sauce_labs do
  before do
    sign_in_user(ENV['User_Email'], ENV['User_Password'])
    expect(page).to have_content 'CSV Reports'
  end

  it 'creates an arm' do
    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'New'
    expect(page).to have_content 'New Arm'

    fill_in 'arm_title', with: 'Test Arm'
    click_on 'Create'
    expect(page).to have_content 'Arm was successfully created.'
  end

  it 'updates an arm' do
    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    click_on 'Edit'
    expect(page).to have_content 'Editing Arm'

    fill_in 'arm_title', with: 'Updated Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'

    expect(page).to have_content 'Title: Updated Arm 1'

    click_on 'Edit'
    expect(page).to have_content 'Editing Arm'

    fill_in 'arm_title', with: 'Arm 1'
    click_on 'Update'
    expect(page).to have_content 'Arm was successfully updated.'

    expect(page).to have_content 'Title: Arm 1'
  end

  it 'destroys an arm' do
    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Test Arm'
    expect(page).to have_content 'Title: Test Arm'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Arm was successfully destroyed.'

    expect(page).to_not have_content 'Test Arm'
  end

  it 'creates a super user' do
    click_on 'Users'
    expect(page).to have_content 'Users'

    click_on 'New'
    fill_in 'user_email', with: 'superuser@test.com'
    check 'user_is_admin'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: Yes'

    expect(page).to have_content 'Email: superuser@test.com'
  end

  it 'updates a super user' do
    click_on 'Users'
    expect(page).to have_content 'Users'

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

  it 'destroys a super user' do
    click_on 'Users'
    expect(page).to have_content 'Users'

    click_on 'superuser@test.com'
    expect(page).to have_content 'Email: superuser@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'superuser@test.com'
  end
end
