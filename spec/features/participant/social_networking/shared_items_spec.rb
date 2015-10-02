# filename: shared_items_spec.rb

describe 'Active participant in a social arm signs in,',
         type: :feature, sauce: sauce_labs do
  describe 'visits the THINK tool,' do
    before do
      unless ENV['safari']
        sign_in_pt(ENV['Participant_Email'], 'participant1',
                   ENV['Participant_Password'])
      end

      visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
    end

    it 'shares THINK > Identifying responses' do
      click_on '#1 Identifying'
      click_on 'Skip'
      fill_in 'thought_content', with: 'Public thought 1'
      accept_social
      expect(page).to have_content 'Thought saved'

      expect(page).to have_content 'Now list another harmful thought...'

      fill_in 'thought_content', with: 'Private thought 1'
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Thought saved'

      visit ENV['Base_URL']
      find_feed_item('Public thought 1')
      expect(page).to_not have_content 'Private thought'

      expect(page).to have_content 'Public thought 1'

      within('.list-group-item.ng-scope', text: 'Public thought 1') do
        shared_time = Time.now - 60
        expect(page)
          .to have_content "Today at #{shared_time.strftime('%l:%M %p')}"
      end
    end

    it 'shares Add a New Thought responses' do
      click_on 'Add a New Thought'
      fill_in 'thought_content', with: 'Public thought 3'
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
      fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
      fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
      page.execute_script('window.scrollTo(0,5000)')
      accept_social
      expect(page).to have_content 'Thought saved'

      page.execute_script('window.scrollTo(0,5000)')
      find('.btn.btn-primary.pull-right', text: 'Next').click
      expect(page).to have_content 'Add a New Thought'

      visit ENV['Base_URL']
      find_feed_item('Public thought 3')
      expect(page).to have_content 'Public thought 3'

      within('.list-group-item.ng-scope', text: 'Public thought 3') do
        expect(page).to have_content "Today at #{Time.now.strftime('%l:%M %p')}"
      end
    end

    it 'does not share Add a New Thought responses' do
      click_on 'Add a New Thought'
      fill_in 'thought_content', with: 'Private thought 2'
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
      fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
      fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
      choose 'No'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Next'
      expect(page).to have_content 'Thought saved'

      page.execute_script('window.scrollTo(0,5000)')
      find('.btn.btn-primary.pull-right', text: 'Next').click
      expect(page).to have_content 'Add a New Thought'

      visit ENV['Base_URL']
      find_feed_item('Public thought 1')
      expect(page).to_not have_content 'Private thought 2'

      expect(page).to have_content 'Public thought 1'
    end
  end

  describe 'visits the DO tool,' do
    before do
      unless ENV['safari']
        sign_in_pt(ENV['Participant_Email'], 'participant1',
                   ENV['Participant_Password'])
      end

      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
    end

    # Monitoring an activity is not longer something can be shared, holding
    # on to the code in case it is reinstated in some way
    # it 'shares DO > Awareness responses' do
    #   click_on '#1 Awareness'
    #   click_on 'Next'
    # find('h1', text: 'Just a slide')
    # click_on 'Next'
    #   select "#{Date.today.strftime('%a')} 6 AM",
    #          from: 'awake_period_start_time'
    #   select "#{Date.today.strftime('%a')} 8 AM",
    #           from: 'awake_period_end_time'
    #   click_on 'Create'
    #   expect(page).to have_content 'Awake Period saved'

    #   fill_in 'activity_type_0', with: 'public sleep 1'
    #   choose_rating('pleasure_0', 6)
    #   choose_rating('accomplishment_0', 7)
    #   fill_in 'activity_type_1', with: 'private sleep'
    #   choose_rating('pleasure_1', 2)
    #   choose_rating('accomplishment_1', 3)
    #   shareable_form = page.all('.new-shareable-form-after-form-groups')
    #   within shareable_form[1] do
    #     choose 'No'
    #   end

    #   accept_social
    #   expect(page).to have_content 'Activity saved'

    #   expect(page).to have_content 'Take a look'

    #   click_on 'Next'
    #   expect(page).to have_content 'Things you found fun.'

    #   click_on 'Next'
    #   expect(page).to have_content "Things that make you feel like you've " \
    #                                'accomplished something.'

    #   click_on 'Next'
    #   expect(page).to have_content 'Add a New Activity'

    #   visit ENV['Base_URL']
    #   find_feed_item('public sleep 1')
    #   expect(page).to_not have_content 'private sleep'

    #   expect(page).to have_content 'public sleep 1'
    # end

    it 'shares DO > Planning responses' do
      click_on '#2 Planning'
      click_on 'Next'
      find('#new_activity_radio').click
      fill_in 'activity_activity_type_new_title', with: 'New public activity'
      page.execute_script('window.scrollTo(0,5000)')
      find('.fa.fa-calendar').click
      pick_tomorrow
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      accept_social
      expect(page).to have_content 'Activity saved'

      page.execute_script('window.scrollTo(0,5000)')
      find('#new_activity_radio').click
      fill_in 'activity_activity_type_new_title', with: 'New private activity'
      page.execute_script('window.scrollTo(0,5000)')
      find('.fa.fa-calendar').click
      pick_tomorrow
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 8)
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'OK...'

      click_on 'Next'
      expect(page).to have_content 'Your Planned Activities'

      click_on 'Next'
      expect(page).to have_content 'Upcoming Activities'

      visit ENV['Base_URL']
      find_feed_item('New public activity')
      expect(page).to_not have_content 'New private activity'

      expect(page).to have_content 'New public activity'

      within('.list-group-item.ng-scope', text: 'New public activity') do
        shared_time = Time.now - 60
        expect(page)
          .to have_content "Today at #{shared_time.strftime('%l:%M %p')}"
      end
    end

    it 'shares Add a New Activity responses' do
      click_on 'Add a New Activity'
      find('#new_activity_radio').click
      fill_in 'activity_activity_type_new_title', with: 'New public activity 2'
      page.execute_script('window.scrollTo(0,5000)')
      find('.fa.fa-calendar').click
      pick_tomorrow
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      accept_social
      expect(page).to have_content 'Activity saved'

      visit ENV['Base_URL']
      find_feed_item('New public activity 2')
      expect(page).to have_content 'New public activity 2'

      within('.list-group-item.ng-scope', text: 'New public activity 2') do
        expect(page).to have_content "Today at #{Time.now.strftime('%l:%M %p')}"
      end
    end

    it 'does not share Add a New Activity responses' do
      click_on 'Add a New Activity'
      find('#new_activity_radio').click
      fill_in 'activity_activity_type_new_title', with: 'New private activity 2'
      page.execute_script('window.scrollTo(0,5000)')
      find('.fa.fa-calendar').click
      pick_tomorrow
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      visit ENV['Base_URL']
      find_feed_item('New public activity 2')
      expect(page).to_not have_content 'New private activity 2'

      expect(page).to have_content 'New public activity 2'
    end
  end
end

describe 'Active participant in a non-social arm signs in,',
         type: :feature, sauce: sauce_labs do
  describe 'visits the THINK tool,' do
    if ENV['safari']
      before(:all) do
        sign_in_pt(ENV['NS_Participant_Email'], 'participant1',
                   ENV['NS_Participant_Password'])
      end
    end

    before do
      unless ENV['safari']
        sign_in_pt(ENV['NS_Participant_Email'], 'participant1',
                   ENV['NS_Participant_Password'])
      end

      visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
    end

    it 'is not able to create a shared item in Identifying' do
      click_on '#1 Identifying'
      expect(page).to have_content 'You are what you think'
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Next'
      expect(page).to have_content 'Helpful thoughts are...'

      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Next'
      expect(page).to have_content 'Harmful thoughts are:'

      click_on 'Next'
      expect(page).to have_content 'Some quick examples...'

      click_on 'Next'
      expect(page).to_not have_content 'Share the content of this thought?'

      fill_in 'thought_content', with: 'Test thought 1'
      click_on 'Next'
      expect(page).to have_content 'Now list another harmful thought...'
    end

    it 'is not able to create a shared item in Add a New Thought' do
      click_on 'Add a New Thought'
      expect(page).to have_content 'Add A New Thought'

      expect(page).to_not have_content 'Share the content of this thought?'
    end
  end

  describe 'visits the DO tool,' do
    if ENV['safari']
      before(:all) do
        sign_in_pt(ENV['NS_Participant_Email'], 'nonsocialpt',
                   ENV['NS_Participant_Password'])
      end
    end

    before do
      unless ENV['safari']
        sign_in_pt(ENV['NS_Participant_Email'], 'nonsocialpt',
                   ENV['NS_Participant_Password'])
      end

      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
    end

    it 'is not able to create a shared item in Awareness' do
      click_on '#1 Awareness'
      click_on 'Next'
      find('h1', text: 'Just a slide')
      click_on 'Next'
      select "#{Date.today.strftime('%a')} 4 AM",
             from: 'awake_period_start_time'
      select "#{Date.today.strftime('%a')} 7 AM", from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to_not have_content 'Share the content of this activity?'
    end

    it 'is not able to create a shared item in Planning' do
      click_on '#2 Planning'
      click_on 'Next'
      expect(page).to have_content 'We want you to plan one fun thing'

      expect(page).to_not have_content 'Share the content of this activity?'
    end

    it 'is not able to create a shared item in Plan a New Activity' do
      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      expect(page).to_not have_content 'Share the content of this activity?'
    end
  end
end
