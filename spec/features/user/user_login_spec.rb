#filename: user_login_spec.rb

#this is to test the login functionality.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Login", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Login", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests

  #Testing a successful login
  it "- success" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  #Testing a failed login
  it "- failure" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'asdf@test.com'
      fill_in 'user_password', :with => 'asdf'
    end
    click_on 'Sign in'
    expect(page).to have_content 'Invalid email address or password'
  end

  #Testing redirect to login screen
  it "- not logged in, redirect" do
    visit ENV['Base_URL']+ '/think_feel_do_dashboard'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  #Testing the Introduction Slideshow if a person hits it who isn't logged in
  it "- not logged in, intro slideshow" do
    visit ENV['Base_URL']+ '/users/sign_in'
    click_on 'Introduction to ThinkFeelDo'
    expect(page).to have_content 'Welcome to ThinkFeelDo'
    click_on 'Continue'
    expect(page).to have_content 'How to Maximize Your Benefit from ThinkFeelDo'
    click_on 'Continue'
    expect(page).to have_content 'What Should I Do When I Log in?'
    click_on 'Continue'
    expect(page).to have_content "How Do I Know What's New on the Site?"
    click_on 'Continue'
    expect(page).to have_content 'What Should I Expect?'
    click_on 'Continue'
    expect(page).to have_content 'What Might Get in the Way?'
    click_on 'Continue'
    expect(page).to have_content 'Get Started'
    click_on 'Done'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  #Testing Forgot Your Password? functionality
  it "- forgot password" do
    visit ENV['Base_URL']+ '/users/sign_in'
    click_on 'Forgot your password?'
    expect(page).to have_content 'Forgot your password?'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
    end
    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'
  end

  #Testing authorization - Clinician
  it "- clinician authorization" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['Clinician_Email']
      fill_in 'user_password', :with => ENV['Clinician_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to_not have_content 'Users'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    expect(page).to_not have_content 'Manage Content'
    click_on 'fake'
    expect(page).to have_content 'Title: fake'
    expect(page).to have_content 'Patients'
    expect(page).to have_content 'Messaging'
    expect(page).to_not have_content 'Manage Tasks'
  end

  #Testing authorization - Researcher
  it "- researcher authorization" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['Researcher_Email']
      fill_in 'user_password', :with => ENV['Researcher_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    expect(page).to_not have_content 'Manage Content'
    click_on 'Access to Everything'
    expect(page).to have_content 'Title: Access to Everything'
    expect(page).to_not have_content 'Messaging'
    expect(page).to have_content 'Manage Tasks'
  end

  #Testing authorization - Content Author
  it "- content author authorization" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['Content_Author_Email']
      fill_in 'user_password', :with => ENV['Content_Author_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Manage Content'
  end

  #Testing authorization - Super User
  it "- super user authorization" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
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
end