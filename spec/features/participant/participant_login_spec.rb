# filename: participant_login_spec.rb

describe 'A visitor to the site,', type: :feature, sauce: sauce_labs do
  it 'is an active participant, signs in' do
    sign_in_pt(ENV['Participant_Email'], 'nonsocialpt',
               ENV['Participant_Password'])
    expect(page).to have_content 'Signed in successfully.'
  end

  it 'is an active participant, signs in, visits another page, uses ' \
     'brand link to get to home page' do
    unless ENV['safari']
      sign_in_pt(ENV['Participant_Email'], 'participant1',
                 ENV['Participant_Password'])
    end

    visit "#{ENV['Base_URL']}/navigator/contexts/LEARN"
    expect(page).to have_content 'Lessons'

    find(:css, '.navbar-brand').click
    expect(page).to have_content "What's on your mind?"
  end

  it 'is an active participant, signs in, signs out' do
    if ENV['safari']
      visit ENV['Base_URL']
    else
      sign_in_pt(ENV['Participant_Email'], 'participant1',
                 ENV['Participant_Password'])
    end

    sign_out('participant1')
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'is not able to log in' do
    visit "#{ENV['Base_URL']}/participants/sign_in"
    within('#new_participant') do
      fill_in 'participant_email', with: 'asdf@example.com'
      fill_in 'participant_password', with: 'asdf'
    end

    click_on 'Sign in'
    expect(page).to have_content 'Invalid email address or password'
  end

  it 'was an active participant in a social arm who has completed' do
    sign_in_pt(ENV['Completed_Pt_Email'], 'participant1',
               ENV['Completed_Pt_Password'])
    find('h1', text: 'HOME')
    find_feed_item('nudged participant1')
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

    unless ENV['safari']
      visit "#{ENV['Base_URL']}/users/sign_in"
      sign_in_user(ENV['Clinician_Email'], 'completer',
                   ENV['Clinician_Password'])
      click_on 'Arms'
      find('h1', text: 'Arms')
      click_on 'Arm 1'
      click_on 'Group 1'
      click_on 'Messaging'
      click_on 'Messages'
      click_on 'Test message from completer'
      expect(page).to have_content 'From You'

      expect(page).to have_content 'Test'

      sign_out('TFD Moderator')
    end
  end

  it 'was an active participant in a mobile arm who has completed' do
    sign_in_pt(ENV['Mobile_Comp_Pt_Email'], 'completer',
               ENV['Mobile_Comp_Pt_Password'])
    find('h1', text: 'HOME')
    visit "#{ENV['Base_URL']}/navigator/contexts/MESSAGES"
    expect(page).to have_content 'Inbox'

    expect(page).to_not have_content 'Compose'
  end

  it 'was an active participant who has withdrawn' do
    visit "#{ENV['Base_URL']}/participants/sign_in"
    if ENV['safari']
      sign_out('mobilecompleter')
    end

    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Old_Participant_Email']
      fill_in 'participant_password', with: ENV['Old_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content "We're sorry, but you can't sign in yet " \
                                 'because you are not assigned to an active ' \
                                 'group'
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
