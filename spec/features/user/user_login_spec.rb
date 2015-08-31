# filename: user_login_spec.rb

describe 'Visitor to the site,', type: :feature, sauce: sauce_labs do
  it 'is an authorized user, signs in' do
    sign_in_user(ENV['User_Email'], 'TFD Moderator', ENV['User_Password'])
    expect(page).to have_content 'Signed in successfully'
  end

  it 'is not an authorized user, fails to sign in' do
    visit "#{ENV['Base_URL']}/users/sign_in"

    if ENV['safari']
      sign_out('TFD Moderator')
    end

    within('#new_user') do
      fill_in 'user_email', with: 'asdf@example.com'
      fill_in 'user_password', with: 'asdf'
    end

    click_on 'Sign in'

    expect(page).to have_content 'Invalid email address or password'
  end

  it 'is not signed, visits a specific page' do
    visit ENV['Base_URL'] + '/think_feel_do_dashboard'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing'
  end

  it 'is not signed in, views the intro slideshow' do
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
    find('h2', text: 'Forgot your password?')

    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
    end

    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with ' \
                                 'instructions on how to reset your ' \
                                 'password in a few minutes.'
  end

  it "is an authorized clinician, only sees what they're authorized to see" do
    sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                 ENV['Clinician_Password'])
    expect(page).to_not have_content "Groups\nCreate, update, delete, and " \
                                     'associate groups with arms along with ' \
                                     "set moderators.\nParticipants\nCreate, " \
                                     'update, and delete participants along ' \
                                     "with assigning them to groups.\nUsers" \
                                     "\nCreate and view super users, " \
                                     'clinicians, researchers, and content ' \
                                     "authors.\nCSV Reports\nDownload data " \
                                     'via csv.'

    click_on 'Arms'
    click_on 'Arm 1'
    expect(page).to_not have_content 'Manage Content'

    click_on 'Group 1'
    expect(page).to have_content 'Patient Dashboard  Group Dashboard  ' \
                                 'Messaging  Moderate  Manage Profile Questions'

    expect(page).to_not have_content 'Manage Tasks'
  end

  it "is an authorized researcher, only sees what they're authorized to see" do
    visit "#{ENV['Base_URL']}/users/sign_in"
    if ENV['safari']
      sign_out('TFD Moderator')
    end

    sign_in_user(ENV['Researcher_Email'], 'TFD Moderator',
                 ENV['Researcher_Password'])
    expect(page).to have_content "Arms\nNavigate to groups and participants " \
                                 "through arms.\nGroups\nCreate, update, " \
                                 'delete, and associate groups with arms ' \
                                 "along with set moderators.\nParticipants" \
                                 "\nCreate, update, and delete participants " \
                                 "along with assigning them to groups.\nUsers" \
                                 "\nCreate and view super users, clinicians, " \
                                 "researchers, and content authors.\nCSV " \
                                 "Reports\nDownload data via csv."

    click_on 'Arms'
    click_on 'Arm 1'
    expect(page).to_not have_content 'Manage Content'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    expect(page).to_not have_content 'Patient Dashboard  Group Dashboard  ' \
                                     'Messaging'

    expect(page).to have_content 'Moderate  Manage Profile Questions  Manage ' \
                                 'Tasks  Edit  Destroy'
  end

  it "is an authorized content author, only sees what they're authorized " \
     'to see' do
    visit "#{ENV['Base_URL']}/users/sign_in"
    if ENV['safari']
      sign_out('TFD Moderator')
    end

    sign_in_user(ENV['Content_Author_Email'], 'TFD Moderator',
                 ENV['Content_Author_Password'])
    expect(page).to_not have_content "Groups\nCreate, update, delete, and " \
                                     'associate groups with arms along with ' \
                                     "set moderators.\nParticipants\nCreate, " \
                                     'update, and delete participants along ' \
                                     "with assigning them to groups.\nUsers" \
                                     "\nCreate and view super users, " \
                                     'clinicians, researchers, and content ' \
                                     "authors.\nCSV Reports\nDownload data " \
                                     'via csv.'

    click_on 'Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'

    expect(page).to_not have_content 'Group 1'
  end

  it 'is an authorized super user' do
    visit "#{ENV['Base_URL']}/users/sign_in"
    if ENV['safari']
      sign_out('TFD Moderator')
    end

    sign_in_user(ENV['User_Email'], 'TFD Moderator',
                 ENV['User_Password'])
    expect(page).to have_content "Arms\nNavigate to groups and participants " \
                                 "through arms.\nGroups\nCreate, update, " \
                                 'delete, and associate groups with arms ' \
                                 "along with set moderators.\nParticipants" \
                                 "\nCreate, update, and delete participants " \
                                 "along with assigning them to groups.\nUsers" \
                                 "\nCreate and view super users, clinicians, " \
                                 "researchers, and content authors.\nCSV " \
                                 "Reports\nDownload data via csv."

    click_on 'Arms'
    expect(page).to have_content 'New'

    click_on 'Arm 1'
    expect(page).to have_content 'Edit  Manage Content  Destroy'

    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Group 1'
    expect(page).to have_content 'Patient Dashboard  Group Dashboard  ' \
                                 'Messaging  Moderate  Manage Profile ' \
                                 'Questions  Manage Tasks  Edit  Destroy'
  end

  it 'is an authorized super user, uses brand link to return to home page' do
    if ENV['safari']
      visit "#{ENV['Base_URL']}/users/sign_in"
    else
      sign_in_user(ENV['User_Email'], 'TFD Moderator',
                   ENV['User_Password'])
    end

    click_on 'Arms'
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing'

    find('.navbar-brand').click
    expect(page).to have_content 'Arms'
  end
end
