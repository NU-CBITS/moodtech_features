# filename: coach_groups_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Coach signs in and navigates to Group Dashboard of Group 1', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Clinician_Email']
      fill_in 'user_password', with: ENV['Clinician_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Group Dashboard'
    expect(page).to have_css('h1', text: 'Group Group 1')
  end

  it 'views Group Summary'

  it 'uses the links within Group Summary'

  it 'views Logins by Week'

  it 'views Lesson View Summary'

  it 'views Thoughts'

  it 'views Activities Past'

  it 'views Activities Future'

  it 'views Goals'

  it 'views Comments'

  it 'vies On-My-Mind Statements'

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
