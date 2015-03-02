# filename: content_author_lessons_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Content Author signs in and navigates to Lesson Modules tool', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Content_Author_Email']
      fill_in 'user_password', with: ENV['Content_Author_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    click_on 'Manage Content'
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
  end

  it 'creates a new lesson' do
    click_on 'New'
    fill_in 'lesson_title', with: 'Test lesson'
    fill_in 'lesson_position', with: '19'
    click_on 'Create'
    expect(page).to have_content 'Successfully created lesson'

    expect(page).to have_content 'Test lesson'

    expect(page).to have_content 'Add Video Slide'
  end

  it 'updates title of a lesson' do
    click_on 'Do - Awareness Introduction'
    expect(page).to have_content 'This is just the beginning...'

    page.all(:link, 'Edit')[0].click
    fill_in 'lesson_title', with: 'Do - Awareness Introduction 123'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'

    expect(page).to have_content 'Do - Awareness Introduction 123'

    expect(page).to have_content 'Add Video Slide'

    page.all(:link, 'Edit')[0].click
    fill_in 'lesson_title', with: 'Do - Awareness Introduction'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'

    expect(page).to have_content 'Do - Awareness Introduction'

    expect(page).to have_content 'Add Video Slide'
  end

  it 'updates position of lessons by using drag and drop sorting' do
    lesson_value = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[11]/td[2]/a/p').text
    source = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[11]/td[1]/span/i')
    target = page.find(:xpath, 'html/body/div[1]/div/div/div[2]/table/tbody/tr[9]/td[1]/span/i')
    source.drag_to(target)
    within('tr:nth-child(9)') do
      expect(page).to have_content lesson_value
    end
  end

  it 'destroys lesson' do
    within('tr', text: 'Test lesson') do
      find('.btn.btn-danger').click
    end

    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test lesson'
  end

  it 'uses breadcrumbs to return home' do
    click_on 'Arm'
    within('.breadcrumb') do
      click_on 'Arms'
    end

    expect(page).top have_content 'Arm 3'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
