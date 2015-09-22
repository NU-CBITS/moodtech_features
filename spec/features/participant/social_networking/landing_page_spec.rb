# filename: landing_page_spec.rb

describe 'SocialNetworking Landing Page, ', type: :feature, sauce: sauce_labs do
  describe 'Active participant in social arm signs in,' do
    before do
      unless ENV['safari']
        sign_in_pt(ENV['Participant_Email'], 'participant1',
                   ENV['Participant_Password'])
      end

      visit ENV['Base_URL']
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

      answer_profile_question('What are your hobbies?', '781294868', 'Running')

      expect(page).to_not have_content 'Fill out your profile so other ' \
                                       'group members can get to know you!'

      answer_profile_question('What is your favorite color?', '932760744', 'Blue')
      page.execute_script('window.scrollBy(0,500)')
      answer_profile_question('Animal, vegetable or mineral?', '10484799', 'Mineral')
      page.execute_script('window.scrollBy(0,500)')
      answer_profile_question('Group 1 profile question', '933797305', 'Group 1')
      within('.panel.panel-success.ng-scope',
             text: 'Group 1 profile question') do
        expect(page).to have_css '.fa.fa-pencil'
      end

      visit ENV['Base_URL']
      find_feed_item('Shared a Profile: Welcome, participant1')
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
        click_on 'Likes (0)'
        find('p', text: 'Liked by')
        click_on 'Like'
        expect(page).to have_content 'Likes (1)'
      end
    end

    it 'comments on a nudge post' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      within first('.list-group-item.ng-scope', text: 'nudged participant1') do
        click_on 'Comments (0)'
        page.execute_script('window.scrollTo(0,5000)')
        click_on 'Add Comment'
        expect(page).to have_content 'What do you think?'

        fill_in 'comment-text', with: 'Sweet Dude!'
        page.execute_script('window.scrollTo(0,5000)')
        click_on 'Save'
        expect(page).to have_content 'Comments (1)'

        expect(page).to have_content 'participant1: Sweet Dude!'
      end
    end

    it 'checks for due date of a goal post' do
      find('h1', text: 'HOME')
      find_feed_item('nudged participant1')
      within first('.list-group-item.ng-scope', text: 'a Goal: p1 alpha') do
        page.execute_script('window.scrollTo(0,5000)')
        click_on 'More'
        expect(page)
          .to have_content "due #{Date.today.strftime('%b %e %Y')}"
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
      unless ENV['safari']
        sign_in_pt(ENV['Participant_Email'], 'participant1',
                   ENV['Participant_Password'])
      end

      visit ENV['Base_URL']
      page.driver.browser.manage.window.resize_to(400, 800)
      visit ENV['Base_URL']
    end

    after do
      page.driver.browser.manage.window.resize_to(1280, 743)
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

    it 'returns to the home page and still sees the feed' do
      visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
      expect(page).to have_content 'Add a New Thought'

      find('#hamburger_button').click
      find('a', text: 'Home').click
      find('.panel-title', text: 'To Do')
    end
  end

  describe 'Active participant signs in,' do
    before do
      sign_in_pt(ENV['Participant_4_Email'], 'participant1',
                 ENV['Participant_4_Password'])
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

      answer_profile_question('What are your hobbies?', '803829648', 'Running')

      visit ENV['Base_URL']
      within('.panel.panel-default.ng-scope', text: 'To Do') do
        expect(page).to_not have_link 'Create a Profile'
        expect(page).to have_content 'You are all caught up! Great work!'
      end
    end
  end
end
