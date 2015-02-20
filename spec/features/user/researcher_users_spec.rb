# filename: researcher_users_spec.rb
require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Research, Users', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Researcher_Email']
      fill_in 'user_password', with: ENV['Researcher_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content 'CSV Reports'
    click_on 'Users'
    expect(page).to have_content 'Users'
  end

  # tests
  # Researchers
  # Testing creating a Researcher
  it '- create a researcher' do
    click_on 'New'
    fill_in 'user_email', with: 'researcher@test.com'
    check 'user_user_roles_researcher'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: researcher@test.com'

    expect(page).to have_content 'Roles: Researcher'
  end

  # Testing updating a researcher
  it '- update a researcher' do
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

  # Testing detroying a researcher
  it '- destroy a researcher' do
    click_on 'researcher@test.com'
    expect(page).to have_content 'Email: researcher@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'researcher@test.com'
  end

  # Clinicians
  # Testing creating a clinician
  it '- create a clincian' do
    click_on 'New'
    fill_in 'user_email', with: 'clinician@test.com'
    check 'user_user_roles_clinician'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: clinician@test.com'

    expect(page).to have_content 'Roles: Clinician'
  end

  # Testing updating a clinician
  it '- update a clinician' do
    click_on ENV['Clinician_Email']
    expect(page).to have_content 'Email: ' + ENV['Clinician_Email']
    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    check 'user_user_roles_content_author'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: ' + ENV['Clinician_Email']

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

    expect(page).to have_content 'Email: ' + ENV['Clinician_Email']

    expect(page).to have_content 'Roles: Clinician'

    expect(page).to_not have_content 'Roles: Content Author and Clinician'
  end

  # Testing detroying a clinician
  it '- destroy a clinician' do
    click_on 'clinician@test.com'
    expect(page).to have_content 'Email: clinician@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'clinician@test.com'
  end

  # Content Authors
  # Testing creating a content author
  it '- create a content author' do
    click_on 'New'
    fill_in 'user_email', with: 'contentauthor@test.com'
    check 'user_user_roles_content_author'
    click_on 'Create'
    expect(page).to have_content 'User was successfully created.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: contentauthor@test.com'

    expect(page).to have_content 'Roles: Content Author'
  end

  # Testing updating a content author
  it '- update a content author' do
    click_on ENV['Content_Author_Email']
    expect(page).to have_content 'Email: ' + ENV['Content_Author_Email']

    click_on 'Edit'
    expect(page).to have_content 'Editing User'

    check 'user_user_roles_clinician'
    click_on 'Update'
    expect(page).to have_content 'User was successfully updated.'

    expect(page).to have_content 'Super User: No'

    expect(page).to have_content 'Email: ' + ENV['Content_Author_Email']

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

    expect(page).to have_content 'Email: ' + ENV['Content_Author_Email']

    expect(page).to have_content 'Roles: Content Author'

    expect(page).to_not have_content 'Roles: Clinician and Content Author'
  end

  # Testing detroying a content author
  it '- destroy a content author' do
    click_on 'contentauthor@test.com'
    expect(page).to have_content 'Email: contentauthor@test.com'

    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'User was successfully destroyed.'

    expect(page).to_not have_content 'contentauthor@test.com'
  end
end
