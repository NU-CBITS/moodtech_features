# filename: user_bugs_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'User Dashboard Bugs', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
      fill_in 'user_password', with: ENV['User_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  # tests
  # This will be updated as bugs come up
end
