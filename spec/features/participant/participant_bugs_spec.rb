# filename: participant_bugs_spec.rb

# this file is to test bug fixes

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# to run locally comment this block out
# describe 'Participant Bugs', type: :feature, sauce: true do
#   before(:each) do
#     visit ENV['Base_URL'] + '/participants/sign_in'
#     within('#new_participant') do
#       fill_in 'participant_email', with: ENV['Participant_Email']
#       fill_in 'participant_password', with: ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#   end

# to run on Sauce Labs comment this block out
describe 'Participant Bugs', type: :feature, sauce: false do
  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  # tests
end
