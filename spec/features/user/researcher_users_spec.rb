# filename: researcher_users_spec.rb

describe 'Research signs in and navigates to Users',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_user(ENV['Researcher_Email'], ENV['Researcher_Password'])

    expect(page).to have_content 'CSV Reports'
    click_on 'Users'
    expect(page).to have_content 'Users'
  end

  it 'creates a researcher' do
    click_on 'New'
    fill_in 'user_email', with: 'researcher@test.com'
    check 'user_user_roles_researcher'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: researcher@test.com'

    expect(page).to have_content 'Roles: Researcher'
  end

  it 'updates a researcher' do
    click_on 'researcher@test.com'
    expect(page).to have_content 'Email: researcher@test.com'

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: researcher@test.com'

    if page.has_text?('Roles: Researcher and Clinician')
      expect(page).to_not have_content 'Roles: Clinician and Researcher'
    else
      expect(page).to have_content 'Roles: Clinician and Researcher'
    end

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: researcher@test.com'

    expect(page).to have_content 'Roles: Researcher'

    expect(page).to_not have_content 'Roles: Clinician and Researcher'
  end

  it 'destroys a researcher' do
    click_on 'researcher@test.com'
    expect(page).to have_content 'Email: researcher@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'researcher@test.com'
  end

  it 'creates a clinician' do
    click_on 'New'
    fill_in 'user_email', with: 'clinician@test.com'
    check 'user_user_roles_clinician'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: clinician@test.com'

    expect(page).to have_content 'Roles: Clinician'
  end

  it 'updates a clinician' do
    click_on ENV['Clinician_Email']
    expect(page).to have_content "Email: #{ENV['Clinician_Email']}"
    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    check 'user_user_roles_content_author'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content "Email: #{ENV['Clinician_Email']}"

    if page.has_text?('Roles: Content Author and Clinician')
      expect(page).to_not have_content 'Roles: Clinician and Content Author'

    else
      expect(page).to have_content 'Roles: Clinician and Content Author'
    end

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    uncheck 'user_user_roles_content_author'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content "Email: #{ENV['Clinician_Email']}"

    expect(page).to have_content 'Roles: Clinician'

    expect(page).to_not have_content 'Roles: Content Author and Clinician'
  end

  it 'destroys a clinician' do
    click_on 'clinician@test.com'
    expect(page).to have_content 'Email: clinician@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'clinician@test.com'
  end

  it 'creates a content author' do
    click_on 'New'
    fill_in 'user_email', with: 'contentauthor@test.com'
    check 'user_user_roles_content_author'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: contentauthor@test.com'

    expect(page).to have_content 'Roles: Content Author'
  end

  it 'updates a content author' do
    click_on ENV['Content_Author_Email']
    expect(page).to have_content "Email: #{ENV['Content_Author_Email']}"

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content "Email: #{ENV['Content_Author_Email']}"

    if page.has_text?('Roles: Content Author and Clinician')
      expect(page).to_not have_content 'Roles: Clinician and Content Author'

    else
      expect(page).to have_content 'Roles: Clinician and Content Author'
    end

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    uncheck 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content "Email: #{ENV['Content_Author_Email']}"

    expect(page).to have_content 'Roles: Content Author'

    expect(page).to_not have_content 'Roles: Clinician and Content Author'
  end

  it 'destroys a content author' do
    click_on 'contentauthor@test.com'
    expect(page).to have_content 'Email: contentauthor@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
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
  end
end
