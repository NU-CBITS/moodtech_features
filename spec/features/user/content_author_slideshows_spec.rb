# filename: content_author_slideshows_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Content Author signs in and navigate to Slideshows tool', type: :feature, sauce: sauce_labs do
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
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'
  end

  it 'creates a slideshow' do
    click_on 'New'
    expect(page).to have_content 'New Slideshow'

    fill_in 'slideshow_title', with: 'Test slideshow'
    click_on 'Create'
    expect(page).to have_content 'Successfully created slideshow'

    expect(page).to have_content 'Test slideshow'
  end

  it 'updates slideshow' do
    click_on 'Home Intro'
    expect(page).to have_content 'Slideshow'

    expect(page).to have_content 'Home Intro'

    expect(page).to have_content 'Anchors'

    page.all('a', text: 'Edit')[0].click
    expect(page).to have_content 'Edit Slideshow'

    fill_in 'slideshow_title', with: 'Home Introduction 123'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slideshow'

    click_on 'Home Introduction 123'
    expect(page).to have_content 'Slideshow'

    expect(page).to have_content 'Home Introduction 123'

    expect(page).to have_content 'Anchors'

    page.all('a', text: 'Edit')[0].click
    expect(page).to have_content 'Edit Slideshow'

    fill_in 'slideshow_title', with: 'Home Intro'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slideshow'
  end

  it 'destroys slideshow' do
    click_on 'Test slideshow'
    click_on 'Delete'
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test slideshow'
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
