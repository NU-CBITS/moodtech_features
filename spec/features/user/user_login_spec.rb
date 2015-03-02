# filename: user_login_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Visitor to the site', type: :feature, sauce: sauce_labs do
  it 'is an authorized user and signs in' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
      fill_in 'user_password', with: ENV['User_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  it 'is not an authorized user and fails to sign in' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: 'asdf@test.com'
      fill_in 'user_password', with: 'asdf'
    end

    click_on 'Sign in'
    expect(page).to have_content 'Invalid email address or password'
  end

  it 'is not signed and visits a specific page' do
    visit ENV['Base_URL'] + '/think_feel_do_dashboard'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  it 'is not signed in and views the intro slideshow' do
    visit ENV['Base_URL'] + '/users/sign_in'
    click_on 'Introduction to ThinkFeelDo'
    expect(page).to have_content 'Welcome to ThiFeDo'

    click_on 'Done'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'uses the forgot password functionality' do
    visit ENV['Base_URL'] + '/users/sign_in'
    click_on 'Forgot your password?'
    expect(page).to have_content 'Forgot your password?'

    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
    end

    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'
  end

  it 'is an authorized clinician, only seeing what they are authorized to see' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Clinician_Email']
      fill_in 'user_password', with: ENV['Clinician_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to_not have_content 'Users'

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    expect(page).to_not have_content 'Manage Content'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    expect(page).to have_content 'Patient Dashboard'

    expect(page).to have_content 'Messaging'

    expect(page).to_not have_content 'Manage Tasks'
  end

  it 'is an authorized researcher, only seeing what they are authorized to see' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Researcher_Email']
      fill_in 'user_password', with: ENV['Researcher_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content 'Arms'

    expect(page).to have_content 'Groups'

    expect(page).to have_content 'Participants'

    expect(page).to have_content 'Users'

    expect(page).to have_content 'CSV Reports'

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    expect(page).to_not have_content 'Manage Content'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    expect(page).to_not have_content 'Messaging'

    expect(page).to have_content 'Manage Tasks'
  end

  it 'is an authorized content author, only seeing what they are authorized to see' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Content_Author_Email']
      fill_in 'user_password', with: ENV['Content_Author_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    expect(page).to_not have_content 'Group 1'
  end

  it 'is an authorized super user' do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
      fill_in 'user_password', with: ENV['User_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content 'Arms'

    expect(page).to have_content 'Groups'

    expect(page).to have_content 'Participants'

    expect(page).to have_content 'Users'

    expect(page).to have_content 'CSV Reports'

    click_on 'Arms'
    expect(page).to have_content 'New'

    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    expect(page).to have_content 'Edit'
  end

  it 'is an authorized super user that uses the brand link to return to the home page' do
    click_on 'Arms'
    expect(page).to have_content 'New'

    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    within('.collapse.navbar-collapse') do
      click_on 'ThinkFeelDo'
    end

    expect(page).to have_content 'Arms'
  end
end
