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
    expect(page).to have_content 'Listing Arms'
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/form/div[4]/div/textarea').set 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vitae viverra leo, at tincidunt enim. Nulla vitae enim nulla. Suspendisse.'
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[1]/span[3]/a[1]').click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[1]/span[3]/a[1]').click
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

    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[2]').click
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/form/div[5]/div/textarea').set 'This is a video slide'
    click_on 'Create'
    expect(page).to have_content 'Successfully created slide for lesson'
  end

  # testing updating a video slide in a lesson
  it '- updating a video slide in a lesson' do
    click_on 'Lesson Modules'
    expect(page).to have_content 'Listing Lesson Modules'
    click_on 'Testing adding/updating slides/lessons'
    expect(page).to have_content 'Test video slide 2'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[1]').click
    expect(page).to have_content 'Edit Slide'
    expect(page).to have_content 'Test video slide 2'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slide for lesson'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[1]').click
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[2]').click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test video slide 2'
  end

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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/form/div[4]/div/textarea').set 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vitae viverra leo, at tincidunt enim. Nulla vitae enim nulla. Suspendisse.'
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[2]/span[3]/a[1]').click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Video Slide'
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[2]/span[3]/a[1]').click
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

    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[2]').click
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/form/div[5]/div/textarea').set 'This is a video slide'
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[4]/span[3]/a[1]').click
    expect(page).to have_content 'Edit Slide'

    uncheck 'slide_is_title_visible'
    click_on 'Update'
    expect(page).to have_content 'Add Slide'

    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[4]/span[3]/a[1]').click
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
    find(:xpath, 'html/body/div[1]/div/div/div[2]/ol/li[5]/span[3]/a[2]').click
    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test video slide 2'
  end
end
