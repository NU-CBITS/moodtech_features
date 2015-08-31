# filename: researcher_users_spec.rb

describe 'Research signs in, navigates to Users,',
         type: :feature, sauce: sauce_labs do
  before do
    unless ENV['safari']
      sign_in_user(ENV['Researcher_Email'], 'TFD Moderator',
                   ENV['Researcher_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/users"
  end

  it 'creates a researcher' do
    click_on 'New'
    fill_in 'user_email', with: 'researcher@test.com'
    check 'user_user_roles_researcher'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content "Super User: No\nEmail: researcher@test.com" \
                                 "\nRoles: Researcher"
  end

  it 'updates a researcher' do
    click_on 'researcher@test.com'
    click_on 'Edit'
    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content "Super User: No\nEmail: researcher@test.com"

    unless page.has_text?('Roles: Researcher and Clinician')
      expect(page).to have_content 'Roles: Clinician and Researcher'
    end

    click_on 'Edit'
    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to_not have_content 'Roles: Clinician and Researcher'
  end

  it 'destroys a researcher' do
    click_on 'researcher@test.com'
    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'researcher@test.com'
  end

  it 'creates a clinician' do
    click_on 'New'
    fill_in 'user_email', with: 'clinician@test.com'
    check 'user_user_roles_clinician'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content "Super User: No\nEmail: clinician@test.com" \
                                 "\nRoles: Clinician"
  end

  it 'updates a clinician' do
    click_on ENV['Clinician_Email']
    click_on 'Edit'
    check 'user_user_roles_content_author'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content "Super User: No\nEmail: " \
                                 "#{ENV['Clinician_Email']}"

    unless page.has_text?('Roles: Content Author and Clinician')
      expect(page).to have_content 'Roles: Clinician and Content Author'
    end

    click_on 'Edit'
    uncheck 'user_user_roles_content_author'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to_not have_content 'Roles: Content Author and Clinician'
  end

  it 'destroys a clinician' do
    click_on 'clinician@test.com'
    expect(page).to have_content 'Email: clinician@test.com'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'clinician@test.com'
  end

  it 'creates a content author' do
    click_on 'New'
    fill_in 'user_email', with: 'contentauthor@test.com'
    check 'user_user_roles_content_author'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No' \
                                 "\nEmail: contentauthor@test.com" \
                                 "\nRoles: Content Author"
  end

  it 'updates a content author' do
    click_on ENV['Content_Author_Email']
    click_on 'Edit'
    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content "Super User: No\nEmail: " \
                                 "#{ENV['Content_Author_Email']}"

    unless page.has_text?('Roles: Content Author and Clinician')
      expect(page).to have_content 'Roles: Clinician and Content Author'
    end

    click_on 'Edit'
    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to_not have_content 'Roles: Clinician and Content Author'
  end

  it 'destroys a content author' do
    click_on 'contentauthor@test.com'
    expect(page).to have_content 'Email: contentauthor@test.com'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'contentauthor@test.com'
  end

  it 'uses breadcrumbs to return to home' do
    click_on ENV['Content_Author_Email']
    expect(page).to have_content 'Super User:'

    click_on 'Users'
    within('.breadcrumb') do
      click_on 'Users'
    end

    expect(page).to have_content 'New'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'

    sign_out('TFD Moderator')
  end
end
