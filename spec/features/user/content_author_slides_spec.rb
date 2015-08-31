# filename: content_author_slides_spec.rb

describe 'Content Author signs in, navigates to Arm 1,',
         type: :feature, sauce: sauce_labs do
  describe 'navigates to Lesson Modules, selects a lesson,' do
    before do
      unless ENV['safari']
        sign_in_user(ENV['Content_Author_Email'], 'TFD Moderator',
                     ENV['Content_Author_Password'])
      end

      visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
      click_on 'Arm 1'
      click_on 'Manage Content'
      click_on 'Lesson Modules'
      find('h1', text: 'Listing Lesson Modules')
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Testing adding/updating slides/lessons'
    end

    it 'creates a slide' do
      click_on 'Add Slide'
      fill_in 'slide_title', with: 'Test slide 2'
      uncheck 'slide[is_title_visible]'
      find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur ' \
                            'adipiscing elit. Vivamus vitae viverra leo, at ' \
                            'tincidunt enim. Nulla vitae enim. Suspendisse.'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test slide 2'
    end

    it 'updates a slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[1].click
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[1].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'
    end

    it 'views a slide' do
      click_on 'Slide 2'
      expect(page).to have_content 'Log in once a day'

      click_on 'Done'
      expect(page).to have_content "It's simple."
    end

    it 'destroys a slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.driver.execute_script('window.confirm = function() {return true}')
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      expect(page).to_not have_content 'Test slide 2'
    end

    it 'adds a video slide' do
      click_on 'Add Video Slide'
      fill_in 'slide_title', with: 'Test video slide 2'
      fill_in 'slide_options_vimeo_id', with: '111087687'
      uncheck 'slide[is_title_visible]'
      find('.md-input').set 'This is a video slide'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test video slide 2'
    end

    it 'updates a video slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[5].click
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[5].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'
    end

    it 'views a video slide' do
      click_on 'Test video slide 2'
      expect(page).to have_content 'This is a video slide'
    end

    it 'destroys a video slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.driver.execute_script('window.confirm = function() {return true}')
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      expect(page).to_not have_content 'Test video slide 2'
    end

    it 'adds an audio slide' do
      click_on 'Add Audio Slide'
      fill_in 'slide_title', with: 'Test audio slide'
      fill_in 'slide_options_audio_url', with: ENV['Audio_File']
      find('.md-input').set 'This is an audio slide'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test audio slide'
    end

    it 'updates an audio slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[5].click
      expect(page).to have_content 'Edit Slide'
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[5].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'
    end

    it 'deletes an audio slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.driver.execute_script('window.confirm = function() {return true}')
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      expect(page).to_not have_content 'Test audio slide'
    end
  end

  describe 'navigates to Slideshows, selects a slideshow,' do
    before do
      unless ENV['safari']
        sign_in_user(ENV['Content_Author_Email'], 'TFD Moderator',
                     ENV['Content_Author_Password'])
      end

      visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
      click_on 'Arm 1'
      click_on 'Manage Content'
      click_on 'Slideshows'
      find('h1', text: 'Listing Slideshows')
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Testing adding/updating slides/lessons'
    end

    it 'adds a slide' do
      click_on 'Add Slide'
      fill_in 'slide_title', with: 'Test slide 2'
      uncheck 'slide[is_title_visible]'
      find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur ' \
                            'adipiscing elit. Vivamus vitae viverra leo, at ' \
                            'tincidunt enim. Nulla vitae enim. Suspendisse.'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Test slide 2'
    end

    it 'updates a slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[1].click
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Add Video Slide'

      page.all('a', text: 'Edit')[1].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Add Video Slide'
    end

    it 'views a slide' do
      click_on 'Slide 2'
      expect(page).to have_content "Log in once a day and tell us you're doing."

      click_on 'Done'
      expect(page).to have_content "It's simple"
    end

    it 'destroys a slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      within('li:nth-child(5)') do
        page.driver.execute_script('window.confirm = function() {return true}')
        click_on 'Remove'
      end

      expect(page).to_not have_content 'Test slide 2'
    end

    it 'adds a video slide' do
      click_on 'Add Video Slide'
      fill_in 'slide_title', with: 'Test video slide 2'
      fill_in 'slide_options_vimeo_id', with: '107231188'
      uncheck 'slide[is_title_visible]'
      find('.md-input').set 'This is a video slide'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Test video slide 2'
    end

    it 'updates a video slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[4].click
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Add Slide'

      page.all('a', text: 'Edit')[4].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Add Slide'
    end

    it 'views a video slide' do
      click_on 'Test video slide 2'
      expect(page).to have_content 'This is a video slide'
    end

    it 'destroys a video slideo' do
      find('small', text: 'Testing adding/updating slides/lessons')
      within('li:nth-child(5)') do
        page.driver.execute_script('window.confirm = function() {return true}')
        click_on 'Remove'
      end

      expect(page).to_not have_content 'Test video slide 2'
    end

    it 'adds an audio slide' do
      click_on 'Add Audio Slide'
      fill_in 'slide_title', with: 'Test audio slide'
      fill_in 'slide_options_audio_url', with: ENV['Audio_File']
      find('.md-input').set 'This is an audio slide'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Create'
      expect(page).to have_content 'Test audio slide'
    end

    it 'updates an audio slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      page.all('a', text: 'Edit')[5].click
      uncheck 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Testing adding/updating slides/lessons'

      page.all('a', text: 'Edit')[5].click
      check 'slide[is_title_visible]'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Update'
      expect(page).to have_content 'Test audio slide'
    end

    it 'deletes an audio slide' do
      find('small', text: 'Testing adding/updating slides/lessons')
      within('li:nth-child(5)') do
        page.driver.execute_script('window.confirm = function() {return true}')
        click_on 'Remove'
      end

      expect(page).to_not have_content 'Test audio slide'
    end

    it 'adds table of contents' do
      click_on 'Add Table of Contents'
      within '.ui-sortable' do
        expect(page).to have_content 'Table of Contents'
      end
    end

    it 'removes table of contents' do
      click_on 'Destroy Table of Contents'
      within '.ui-sortable' do
        expect(page).to_not have_content 'Table of Contents'
      end
    end
  end
end
