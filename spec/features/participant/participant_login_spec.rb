# filename: participant_login_spec.rb

describe 'A visitor to the site,', type: :feature, sauce: sauce_labs do
  it 'is an active participant, signs in' do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
    expect(page).to have_content 'Signed in successfully.'
  end

  it 'is an active participant, signs in, visits another page, uses ' \
     'brand link to get to home page' do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

    visit "#{ENV['Base_URL']}/navigator/contexts/LEARN"
    expect(page).to have_content 'Lessons'

    find(:css, '.navbar-brand').click
    expect(page).to have_content "What's on your mind?"
  end

  it 'is an activie participant, signs in, signs out' do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

    within '.navbar-collapse' do
      click_on 'participant1'
      click_on 'Sign Out'
    end

    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'is not able to log in' do
    sign_in_pt('asdf@test.com', 'asdf')
    expect(page).to have_content 'Invalid email address or password'
  end

  it 'was an active participant who has completed' do
    sign_in_pt(ENV['Completed_Pt_Email'], ENV['Completed_Pt_Password'])
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    expect(page).to have_content 'nudged participant1'

    visit "#{ENV['Base_URL']}/navigator/contexts/MESSAGES"

    click_on 'Compose'
    expect(page).to have_content 'To Coach'

    within('#new_message') do
      fill_in 'message_subject', with: 'Test message from completer'
      fill_in 'message_body',
              with: 'Test'
    end

    click_on 'Send'
    expect(page).to have_content 'Message saved'

    visit "#{ENV['Base_URL']}/users/sign_in"
    sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])

    click_on 'Arms'
    find('h1', text: 'Arms')
    click_on 'Arm 1'
    click_on 'Group 1'
    click_on 'Messaging'
    click_on 'Messages'
    click_on 'Test message from completer'
    expect(page).to have_content 'From You'

    expect(page).to have_content 'Test'
  end

  it 'was an active participant who has withdrawn' do
    sign_in_pt(ENV['Old_Participant_Email'], ENV['Old_Participant_Password'])
    expect(page).to have_content "We're sorry, but you can't sign in yet " \
                                 'because you are not assigned to a group'
  end

  it 'tries to visit a specific page, is redirected to log in page' do
    visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing'
  end

  it 'views the intro slideshow' do
    visit ENV['Base_URL']
    click_on 'Introduction to ThinkFeelDo'
    click_on 'Done'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'is an active participant, uses the forgot password functionality' do
    visit ENV['Base_URL']
    click_on 'Forgot your password?'
    find('h2', text: 'Forgot your password?')

    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
    end

    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with ' \
                                 'instructions on how to reset your password ' \
                                 'in a few minutes.'
  end
end
