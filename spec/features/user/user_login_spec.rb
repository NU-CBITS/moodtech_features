# filename: user_login_spec.rb

describe 'Visitor to the site', type: :feature, sauce: sauce_labs do
  it 'is an authorized user and signs in' do
    sign_in_user(ENV['User_Email'], ENV['User_Password'])
  end

  it 'is not an authorized user and fails to sign in' do
    sign_in_user('asdf@test.com', 'asdf')
    expect(page).to have_content 'Invalid email address or password'
  end

  it 'is not signed and visits a specific page' do
    visit ENV['Base_URL'] + '/think_feel_do_dashboard'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing'
  end

  it 'is not signed in and views the intro slideshow' do
    visit "#{ENV['Base_URL']}/users/sign_in"
    click_on 'Introduction to ThinkFeelDo'
    expect(page).to have_content 'Welcome to ThiFeDo'

    click_on 'Done'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'uses the forgot password functionality' do
    visit "#{ENV['Base_URL']}/users/sign_in"
    click_on 'Forgot your password?'
    expect(page).to have_content 'Forgot your password?'

    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
    end

    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with ' \
                                 'instructions on how to reset your ' \
                                 'password in a few minutes.'
  end

  it "is an authorized clinician, only sees what they're authorized to see" do
    sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])

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

  it "is an authorized researcher, only sees what they're authorized to see" do
    sign_in_user(ENV['Researcher_Email'], ENV['Researcher_Password'])

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

  it "is an authorized content author, only sees what they're authorized " \
     'to see' do
    sign_in_user(ENV['Content_Author_Email'], ENV['Content_Author_Password'])

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    expect(page).to_not have_content 'Group 1'
  end

  it 'is an authorized super user' do
    sign_in_user(ENV['User_Email'], ENV['User_Password'])

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

  it 'is an authorized super user, uses brand link to return to home page' do
    sign_in_user(ENV['User_Email'], ENV['User_Password'])

    click_on 'Arms'
    expect(page).to have_content 'New'

    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    find('.navbar-brand').click

    expect(page).to have_content 'Arms'
  end
end
