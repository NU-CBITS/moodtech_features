# filename: content_author_slides_spec.rb

describe 'Content Author signs in, navigates to Arm 1,',
         type: :feature, sauce: sauce_labs do
  describe 'navigates to Lesson Modules, selects a lesson,' do
    before do
      sign_in_user(ENV['Content_Author_Email'], ENV['Content_Author_Password'])
      click_on 'Arms'
      find('h1', text: 'Arms')
      click_on 'Arm 1'
      click_on 'Manage Content'
      click_on 'Lesson Modules'
      click_on 'Testing adding/updating slides/lessons'
    end

    it 'creates a slide' do
      click_on 'Add Slide'
      fill_in 'slide_title', with: 'Test slide 2'
      uncheck 'slide_is_title_visible'
      find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur ' \
                            'adipiscing elit. Vivamus vitae viverra leo, at ' \
                            'tincidunt enim. Nulla vitae enim. Suspendisse.'
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test slide 2'
    end

    it 'updates a slide' do
      page.all('a', text: 'Edit')[1].click
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[1].click
      check 'slide_is_title_visible'
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
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      page.accept_alert 'Are you sure?'
      expect(page).to_not have_content 'Test slide 2'
    end

    it 'adds a video slide' do
      click_on 'Add Video Slide'
      fill_in 'slide_title', with: 'Test video slide 2'
      fill_in 'slide_options_vimeo_id', with: '111087687'
      uncheck 'slide_is_title_visible'
      find('.md-input').set 'This is a video slide'
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test video slide 2'
    end

    it 'updates a video slide' do
      page.all('a', text: 'Edit')[5].click
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[5].click
      check 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'
    end

    it 'views a video slide' do
      click_on 'Test video slide 2'
      expect(page).to have_content 'This is a video slide'
    end

    it 'destroys a video slide' do
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      page.accept_alert 'Are you sure?'
      expect(page).to_not have_content 'Test video slide 2'
    end

    it 'adds an audio slide' do
      click_on 'Add Audio Slide'
      fill_in 'slide_title', with: 'Test audio slide'
      fill_in 'slide_options_audio_url', with: ENV['Audio_File']
      find('.md-input').set 'This is an audio slide'
      click_on 'Create'
      expect(page).to have_content 'Successfully created slide for lesson'

      expect(page).to have_content 'Test audio slide'
    end

    it 'updates an audio slide' do
      page.all('a', text: 'Edit')[5].click
      expect(page).to have_content 'Edit Slide'
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'

      page.all('a', text: 'Edit')[5].click
      check 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated slide for lesson'
    end

    it 'deletes an audio slide' do
      page.all('.btn.btn-danger', text: 'Remove')[4].click
      page.accept_alert 'Are you sure?'
      expect(page).to_not have_content 'Test audio slide'
    end
  end

  describe 'navigates to Slideshows, selects a slideshow,' do
    before do
      sign_in_user(ENV['Content_Author_Email'], ENV['Content_Author_Password'])
      click_on 'Arms'
      find('h1', text: 'Arms')
      click_on 'Arm 1'
      click_on 'Manage Content'
      click_on 'Slideshows'
      click_on 'Testing adding/updating slides/lessons'
    end

    it 'adds a slide' do
      click_on 'Add Slide'
      fill_in 'slide_title', with: 'Test slide 2'
      uncheck 'slide_is_title_visible'
      find('.md-input').set 'Lorem ipsum dolor sit amet, consectetur ' \
                            'adipiscing elit. Vivamus vitae viverra leo, at ' \
                            'tincidunt enim. Nulla vitae enim. Suspendisse.'
      click_on 'Create'
      expect(page).to have_content 'Test slide 2'
    end

    it 'updates a slide' do
      page.all('a', text: 'Edit')[1].click
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Add Video Slide'

      page.all('a', text: 'Edit')[1].click
      check 'slide_is_title_visible'
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
      within('li:nth-child(5)') do
        click_on 'Remove'
      end

      page.accept_alert 'Are you sure?'
      expect(page).to_not have_content 'Test slide 2'
    end

    it 'adds a video slide' do
      click_on 'Add Video Slide'
      fill_in 'slide_title', with: 'Test video slide 2'
      fill_in 'slide_options_vimeo_id', with: '107231188'
      uncheck 'slide_is_title_visible'
      find('.md-input').set 'This is a video slide'
      click_on 'Create'
      expect(page).to have_content 'Test video slide 2'
    end

    it 'updates a video slide' do
      page.all('a', text: 'Edit')[4].click
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Add Slide'

      page.all('a', text: 'Edit')[4].click
      check 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Add Slide'
    end

    it 'views a video slide' do
      click_on 'Test video slide 2'
      expect(page).to have_content 'This is a video slide'
    end

    it 'destroys a video slideo' do
      within('li:nth-child(5)') do
        click_on 'Remove'
      end

      page.accept_alert 'Are you sure?'
      expect(page).to_not have_content 'Test video slide 2'
    end

    it 'adds an audio slide' do
      click_on 'Add Audio Slide'
      fill_in 'slide_title', with: 'Test audio slide'
      fill_in 'slide_options_audio_url', with: ENV['Audio_File']
      find('.md-input').set 'This is an audio slide'
      click_on 'Create'
      expect(page).to have_content 'Test audio slide'
    end

    it 'updates an audio slide' do
      page.all('a', text: 'Edit')[5].click
      uncheck 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Testing adding/updating slides/lessons'

      page.all('a', text: 'Edit')[5].click
      check 'slide_is_title_visible'
      click_on 'Update'
      expect(page).to have_content 'Test audio slide'
    end

    it 'deletes an audio slide' do
      within('li:nth-child(5)') do
        click_on 'Remove'
      end

      page.accept_alert 'Are you sure?'
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
