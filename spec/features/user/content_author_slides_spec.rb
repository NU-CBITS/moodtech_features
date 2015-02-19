# filename: content_author_slides_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Content Author, Slides', type: :feature, sauce: sauce_labs do
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
  end

  # tests
  # testing adding a slide to a lesson
  it '- adding a slide to a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    click_on 'Add Slide'
    expect(page).to have_content 'New Slide for Lesson'

    expect(page).to have_content 'Testing adding/updating slides/lessons'

    fill_in 'slide_title', with: 'Test slide 2'
    uncheck 'slide_is_title_visible'
    find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vitae viverra leo, at tincidunt enim. Nulla vitae enim nulla. Suspendisse.'
    click_on 'Create'
    expect(page).to have_content 'Successfully created slide for lesson'

    expect(page).to have_content 'Test slide 2'
  end

  # testing updating a slide in a lesson
  it '- updating a slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    page.all('a', text: 'Edit')[1].click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'

    page.all('a', text: 'Edit')[1].click
    expect(page).to have_content 'Edit Slide'

    check 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'
  end

  # testing viewing a slide in a lesson
  it '- viewing a slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple."

    click_on 'Slide 2'
    expect(page).to have_content 'Log in once a day'

    click_on 'Done'
    expect(page).to have_content "It's simple."
  end

  # testing destroying a slide in a lesson
  it '- destroying a slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    page.all('.btn.btn-danger', text: 'Remove')[4].click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test slide 2'
  end

  # testing adding a video slide to a lesson
  it '- adding a video slide to a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    click_on 'Add Video Slide'
    expect(page).to have_content 'New Slide for Lesson'

    expect(page).to have_content 'Testing adding/updating slides/lessons'

    fill_in 'slide_title', with: 'Test video slide 2'
    fill_in 'slide_options_vimeo_id', with: '111087687'
    uncheck 'slide_is_title_visible'
    find('.md-input').set 'This is a video slide'
    click_on 'Create'
    expect(page).to have_content 'Successfully created slide for lesson'
  end

  # testing updating a video slide in a lesson
  it '- updating a video slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 2'

    page.all('a', text: 'Edit')[5].click
    expect(page).to have_content 'Edit Slide'

    expect(page).to have_content 'Test video slide 2'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'

    page.all('a', text: 'Edit')[5].click
    expect(page).to have_content 'Edit Slide'

    check 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'
  end

  # testing viewing a video slide in a lesson
  it '- viewing a video slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 2'

    click_on 'Test video slide 2'
    expect(page).to have_content 'This is a video slide'
  end

  # testing destroying a video slide in a lesson
  it '- destroying a video slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 2'

    page.all('.btn.btn-danger', text: 'Remove')[4].click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test video slide 2'
  end

  # testing adding an audio slide in a lesson
  it '- adding an audio slide to a less'

  # testing updating an audio slide in a lesson
  it '- updating an audio slide in a lesson'

  # testing deleting an audio slide in a lesson
  it '- deleting an audio slide from a lesson'

  # testing adding TOC to a lesson
  it '- adding TOC to a lesson'

  # testing removing TOC from a lesson
  it '- removing TOC from a lesson'

  # testing adding a slide to a slideshow
  it '- adding a slide to a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    click_on 'Add Slide'
    expect(page).to have_content 'New Slide'

    fill_in 'slide_title', with: 'Test slide 2'
    uncheck 'slide_is_title_visible'
    find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vitae viverra leo, at tincidunt enim. Nulla vitae enim nulla. Suspendisse.'
    click_on 'Create'
    expect(page).to have_content 'Test slide 2'
  end

  # testing updating a slide in a slideshow
  it '- updating a slide in a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    page.all('a', text: 'Edit')[1].click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Video Slide'

    page.all('a', text: 'Edit')[1].click
    expect(page).to have_content 'Edit Slide'

    check 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Video Slide'
  end

  # testing viewing a slide to a slideshow
  it '- viewing a slide in a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    click_on 'Slide 2'
    expect(page).to have_content "Log in once a day and tell us you're doing."

    click_on 'Done'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'
  end

  # testing destroying a slide in a slideshow
  it '- destroying a slide in a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    page.all('.btn.btn-danger', text: 'Remove')[4].click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test slide 2'
  end

  # testing adding a video slide to a slideshow
  it '- adding a video slide to a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    click_on 'Add Video Slide'
    expect(page).to have_content 'New Slide'

    fill_in 'slide_title', with: 'Test video slide 2'
    fill_in 'slide_options_vimeo_id', with: '107231188'
    uncheck 'slide_is_title_visible'
    find('.md-input').set 'This is a video slide'
    click_on 'Create'
    expect(page).to have_content 'Test video slide 2'
  end

  # testing updating a video slide in a slideshow
  it '- updating a video slide in a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    page.all('a', text: 'Edit')[4].click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Slide'

    page.all('a', text: 'Edit')[4].click
    expect(page).to have_content 'Edit Slide'

    check 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Slide'
  end

  # testing viewing a video slide in a slideshow
  it '- viewing a video slide in a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    click_on 'Test video slide 2'
    expect(page).to have_content 'This is a video slide'
  end

  # testing destroying a video slide to a slideshow
  it '- destroying a video slide to a slideshow' do
    click_on 'Slideshows'
    expect(page).to have_content 'Listing Slideshows'

    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content "It's simple"

    expect(page).to have_content 'Slide 2'

    page.all('.btn.btn-danger', text: 'Remove')[4].click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test video slide 2'
  end

  # testing adding an audio slide in a slideshow
  it '- adding an audio slide to a slideshow'

  # testing updating an audio slide in a slideshow
  it '- updating an audio slide in a slideshow'

  # testing deleting an audio slide in a slideshow
  it '- deleting an audio slide from a slideshow'

  # testing adding TOC to a slideshow
  it '- adding TOC to a slideshow'

  # testing removing TOC from a slideshow
  it '- removing TOC from a slideshow'

  # testing markdown preview within slide editing
  it '- uses markdown editor'

end
