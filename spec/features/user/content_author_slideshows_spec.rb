# filename: content_author_slideshows_spec.rb

describe 'Content Author signs in, navigates to Slideshows tool,',
         type: :feature, sauce: sauce_labs do
  before do
    unless ENV['safari']
      sign_in_user(ENV['Content_Author_Email'], 'TFD Moderator',
                   ENV['Content_Author_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Slideshows'
  end

  it 'creates a slideshow' do
    click_on 'New'
    fill_in 'slideshow_title', with: 'Test slideshow'
    click_on 'Create'
    expect(page).to have_content 'Successfully created slideshow'

    expect(page).to have_content 'Test slideshow'
  end

  it 'updates slideshow' do
    find('h1', text: 'Listing Slideshows')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Home Intro'
    page.all('a', text: 'Edit')[0].click
    fill_in 'slideshow_title', with: 'Home Introduction 123'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slideshow'

    find('h1', text: 'Listing Slideshows')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Home Introduction 123'
    page.all('a', text: 'Edit')[0].click
    fill_in 'slideshow_title', with: 'Home Introduction'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated slideshow'

    expect(page).to have_content 'Home Introduction'
  end

  it 'destroys slideshow' do
    find('h1', text: 'Listing Slideshows')
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Test slideshow'
    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Delete'
    expect(page).to_not have_content 'Test slideshow'
  end

  it 'uses breadcrumbs to return home' do
    expect(page).to have_content 'New'
    click_on 'Arm'
    within('.breadcrumb') do
      click_on 'Arms'
    end

    expect(page).to have_content 'Arm 2'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content "Arms\nNavigate to groups and participants " \
                                 'through arms.'
  end
end
