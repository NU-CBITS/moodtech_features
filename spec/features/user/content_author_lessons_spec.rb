#filename: content_author_lessons_spec.rb

#this is to test the users Arm 1ctionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'



#to run locally comment this line out
# describe "Content Author, Lesson Modules", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Content Author, Lesson Modules", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
  end

#tests
  #Testing creating a lesson
  it "- new lesson" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    click_on 'New'
    fill_in 'lesson_title', :with => 'Test lesson'
    fill_in 'lesson_position', :with => '45'
    click_on 'Create'
    expect(page).to have_content 'Successfully created lesson'
    expect(page).to have_content 'Test lesson'
    expect(page).to have_content 'Add Video Slide'
  end

  #Testing updating a lesson
  it "- updating lesson" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 1'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[1]/a[2]').click
    fill_in 'lesson_title', :with => 'Testing adding/updating slides/lessons 123'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'
    expect(page).to have_content 'Testing adding/updating slides/lessons 123'
    expect(page).to have_content 'Add Video Slide'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[1]/a[2]').click
    fill_in 'lesson_title', :with => 'Testing adding/updating slides/lessons'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'
    expect(page).to have_content 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Add Video Slide'
  end

  #Testing drag and drop lesson sorting
  it "- drag and drop sorting" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    source = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[42]/td[1]/span/i')
    target = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[40]/td[1]/span/i')
    source.drag_to(target)
    within("tr:nth-child(40)") do
      find('#lesson-1032687475>td>a>p')
    end
    within("tr:nth-child(41)") do
      find('#lesson-1032687501>td>a>p')
    end
    source = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[40]/td[1]/span/i')
    target = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[43]/td[1]/span/i')
    source.drag_to(target)
    within("tr:nth-child(40)") do
      find('#lesson-1032687501>td>a>p')
    end
    within("tr:nth-child(42)") do
      find('#lesson-1032687475>td>a>p')
    end
  end

  #Testing destroying  a lesson
  it "- destroy lesson" do
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[44]/td[5]/a[2]').click
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Lesson deleted'
    expect(page).to_not have_content 'Test lesson'
  end
end