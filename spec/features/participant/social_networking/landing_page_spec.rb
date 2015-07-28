# filename: landing_page_spec.rb

describe 'SocialNetworking Landing Page, ', type: :feature, sauce: sauce_labs do
  describe 'Active participant in social arm signs in,' do
    before do
      sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
    end

    it 'creates a profile' do
      click_on 'Create a Profile'
      if page.has_css?('.modal-content')
        within('.modal-content') do
          page.all('img')[2].click
        end
      end

      expect(page).to have_content 'Fill out your profile so other group ' \
                                   'members can get to know you!'

      within('.panel.panel-default.ng-scope', text: 'What are your hobbies?') do
        fill_in 'new-answer-description-781294868', with: 'Running'
        click_on 'Save'
      end

      expect(page).to_not have_content 'Fill out your profile so other group ' \
                                       'members can get to know you!'

      within('.panel.panel-default.ng-scope',
             text: 'What is your favorite color?') do
        fill_in 'new-answer-description-932760744', with: 'Blue'
        click_on 'Save'
      end

      within('.panel.panel-default.ng-scope',
             text: 'Animal, vegetable or mineral?') do
        fill_in 'new-answer-description-10484799', with: 'Mineral'
        click_on 'Save'
      end

      within('.panel.panel-default.ng-scope',
             text: 'Group 1 profile question') do
        fill_in 'new-answer-description-933797305', with: 'Group 1'
        click_on 'Save'
        expect(page).to have_css '.fa.fa-pencil'
      end

      visit ENV['Base_URL']
      # at the moment this is not displaying when run locally but works when
      # run manually on staging
      # find_feed_item('Shared a Profile: Welcome, participant1')
      # expect(page).to have_content 'Shared a Profile: Welcome, participant1'
      expect(page).to_not have_content 'Create a Profile'
    end

    it 'navigates to the profile page from a page other than home' do
      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
      within '.navbar-collapse' do
        click_on 'participant1'
        click_on 'My Profile'
      end

      expect(page).to have_content 'Group 1 profile question'
    end

    it 'creates a whats on your mind post' do
      click_on "What's on your mind?"
      fill_in 'new-on-your-mind-description', with: "I'm feeling happy!"
      click_on 'Save'
      expect(page).to have_content "said I'm feeling happy!"
    end

    it 'selects link in TODO list' do
      click_on 'THINK: Add a New Thought'
      expect(page).to have_content 'Add a New Harmful Thought'
    end

    it 'views another participants profile' do
      within('.profile-border.profile-icon-top',
             text: 'profile question participant') do
        click_on 'profile question participant'
      end

      expect(page).to have_content 'What is your favorite color?'
    end

    it 'likes a whats on your mind post written by another participant' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      philly_comment = page.all('.list-group-item.ng-scope',
                                text: "said it's always sunny in Philadelphia")
      within philly_comment[0] do
        click_on 'Like (0)'
        expect(page).to have_content 'Like (1)'
      end
    end

    it 'comments on a nudge post' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      within first('.list-group-item.ng-scope', text: 'nudged participant1') do
        click_on 'Comment (0)'
        click_on 'Add Comment'
        expect(page).to have_content 'What do you think?'

        fill_in 'comment-text', with: 'Sweet Dude!'
        click_on 'Save'
        expect(page).to have_content 'Comment (1)'

        expect(page).to have_content 'participant1: Sweet Dude!'
      end
    end

    it 'checks for due date of a goal post' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      within first('.list-group-item.ng-scope', text: 'a Goal: p1 alpha') do
        click_on 'More'
        expect(page)
          .to have_content "due #{Date.today.strftime('%b. %e, %Y')}" \
                           ' at 12:00AM'
      end
    end

    it 'checks for a goal that was due yesterday and is now incomplete' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      expect(page).to have_content 'Did Not Complete a Goal: due yesterday'
    end

    it 'does not see an incomplete goal for a goal that was due two days ago' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      expect(page).to_not have_content 'Did Not Complete a Goal: due two days' \
                                       ' ago'
    end
  end

  describe 'Active participant signs in, resizes window to mobile' do
    before do
      sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
      page.driver.browser.manage.window.resize_to(400, 800)
      visit ENV['Base_URL']
    end

    after do
      page.driver.browser.manage.window.resize_to(1080, 618)
    end

    it 'is able to scroll for more feed items' do
      find('.panel-title', text: 'To Do')
      counter = 0
      while page.has_no_css?('.list-group-item.ng-scope',
                             text: 'nudged participant1') && counter < 15
        page.execute_script('window.scrollTo(0,100000)')
        counter += 1
      end

      expect(page).to have_content 'nudged participant1'
    end
  end

  describe 'Active participant signs in,' do
    before do
      sign_in_pt(ENV['Participant_4_Email'], ENV['Participant_4_Password'])
    end

    it 'complete last task in To Do, sees appropriate message' do
      within('.panel.panel-default.ng-scope', text: 'To Do') do
        expect(page).to have_link 'Create a Profile'
        expect(page).to_not have_content 'You are all caught up! Great work!'
      end

      click_on 'Create a Profile'
      if page.has_css?('.modal-content')
        within('.modal-content') do
          page.all('img')[2].click
        end
      end

      expect(page).to have_content 'Fill out your profile so other group ' \
                                   'members can get to know you!'

      within('.panel.panel-default.ng-scope', text: 'What are your hobbies?') do
        fill_in 'new-answer-description-225609157', with: 'Running'
        click_on 'Save'
        expect(page).to have_css '.fa.fa-pencil'
      end

      visit ENV['Base_URL']
      within('.panel.panel-default.ng-scope', text: 'To Do') do
        expect(page).to_not have_link 'Create a Profile'
        expect(page).to have_content 'You are all caught up! Great work!'
      end
    end
  end
end
