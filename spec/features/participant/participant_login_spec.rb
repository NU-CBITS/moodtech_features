# filename: participant_login_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'A visitor to the site,', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
  end

  it 'is an active participant and signs in' do
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  it 'is an active participant, signs in, visits another page, and uses ' \
     'brand link to get to home page' do
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/LEARN'
    expect(page).to have_content 'Lessons'

    find(:css, '.navbar-brand').click
    expect(page).to have_content "What's on your mind?"
  end

  it 'is an activie participant, signs in and signs out' do
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    within '.navbar-collapse' do
      click_on 'participant1'
      click_on 'Sign Out'
    end

    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'is not able to log in' do
    within('#new_participant') do
      fill_in 'participant_email', with: 'asdf@test.com'
      fill_in 'participant_password', with: 'asdf'
    end

    click_on 'Sign in'
    expect(page).to have_content 'Invalid email address or password'
  end

  it 'was an active participant who has completed' do
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Completed_Pt_Email']
      fill_in 'participant_password', with: ENV['Completed_Pt_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'HOME'
  end

  it 'was an active participant in a social arm who has completed'

  it 'was an active participant in a non-social arm who has completed'

  it 'was an active participant who has withdrawn' do
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Old_Participant_Email']
      fill_in 'participant_password', with: ENV['Old_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content "We're sorry, but you can't sign in yet " \
                                 'because you are not assigned to a group'
  end

  it 'tries to visit a specific page and is redirected to log in page' do
    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing'
  end

  it 'views the intro slideshow' do
    click_on 'Introduction to ThinkFeelDo'
    expect(page).to have_content 'Welcome to ThiFeDo'

    click_on 'Done'
    expect(page).to have_content 'You need to sign in or sign up before ' \
                                 'continuing.'
  end

  it 'is an active participant and uses the forgot password functionality' do
    click_on 'Forgot your password?'
    expect(page).to have_content 'Forgot your password?'

    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
    end

    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with ' \
                                 'instructions on how to reset your password ' \
                                 'in a few minutes.'
  end
end
