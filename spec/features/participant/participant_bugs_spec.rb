# filename: participant_bugs_spec.rb

describe 'Participant Bugs', type: :feature, sauce: sauce_labs do
  context 'Participant 1 signs in, navigates to the DO tool,' do
    before do
      sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
    end

    it 'completes Planning without receiving multiple alerts' do
      click_on '#2 Planning'
      click_on 'Next'
      tomorrow = Date.today + 1
      fill_in 'activity_activity_type_new_title', with: 'New planned activity'
      find('.fa.fa-calendar').click
      within('#ui-datepicker-div') do
        click_on tomorrow.strftime('%e')
      end

      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      fill_in 'activity_activity_type_new_title',
              with: 'Another planned activity'
      find('.fa.fa-calendar').click
      within('#ui-datepicker-div') do
        click_on tomorrow.strftime('%e')
      end

      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 8)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      click_on 'Next'
      expect(page).to have_content 'Your Planned Activities'

      click_on 'Next'
      expect(page).to have_content 'Do Landing'
    end

    it 'completes Plan a New Activity without multiple alerts' do
      click_on 'Add a New Activity'
      fill_in 'activity_activity_type_new_title', with: 'New planned activity'
      tomorrow = Date.today + 1
      find('.fa.fa-calendar').click
      within('#ui-datepicker-div') do
        click_on tomorrow.strftime('%e')
      end

      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'
    end

    it 'visits Your Activities, selects Previous Day w/out exception' do
      click_on '#1 Awareness'
      click_on 'Next'
      select "#{Date.today.strftime('%a')} 2 AM",
             from: 'awake_period_start_time'
      select "#{Date.today.strftime('%a')} 3 AM", from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      fill_in 'activity_type_0', with: 'Sleep'
      choose_rating('pleasure_0', 9)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Take a look - does this all seem right? ' \
                                   'Recently, you...'

      click_on 'Next'
      expect(page).to have_content 'Things you found fun.'

      click_on 'Next'
      expect(page).to have_content "Things that make you feel like you've " \
                                   'accomplished something.'

      click_on 'Next'
      expect(page).to have_content 'Add a New Activity'

      click_on 'Your Activities'
      expect(page).to have_content 'Today'

      click_on 'Previous Day'
      expect(page)
        .to have_content 'Daily Averages for ' \
                         "#{Date.today.prev_day.strftime('%b %d, %Y')}"
    end

    it 'completes Awareness, finds the activity properly displayed on feed' do
      click_on '#1 Awareness'
      click_on 'Next'
      select "#{Date.today.strftime('%a')} 4 AM",
             from: 'awake_period_start_time'
      select "#{Date.today.strftime('%a')} 5 AM", from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      fill_in 'activity_type_0', with: 'doing whatever thing'
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 7)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      visit ENV['Base_URL']
      within('.list-group-item.ng-scope',
             text: 'Monitored an Activity: doing whatever thing') do
        within('.actions') do
          find('.fa.fa-folder-open.fa-2x.ng-scope').click
        end
        expect(page).to have_content "actual accomplishment: 7\n" \
                                     'actual pleasure: 6'
      end
    end
  end

  context 'Participant 2 signs in,' do
    before do
      sign_in_pt(ENV['Participant_2_Email'], ENV['Participant_2_Password'])
    end

    it 'navigates to a module from the dropdown, completes the module, the ' \
       'module appears complete on landing page' do
      within('.dropdown-toggle', text: 'FEEL') do
        expect(page).to have_content 'New!'
      end

      find('.dropdown-toggle', text: 'FEEL').click
      within('.dropdown-menu') do
        click_on 'Tracking Your Mood & Emotions'
      end

      select '6', from: 'mood[rating]'
      click_on 'Next'
      expect(page).to have_content 'You just rated your mood as a 6 (Good)'

      select 'anxious', from: 'emotional_rating_emotion_id'
      select 'negative', from: 'emotional_rating_is_positive'
      select '4', from: 'emotional_rating[rating]'

      click_on 'Next'
      expect(page).to have_content 'Emotional Rating saved'

      visit "#{ENV['Base_URL']}/navigator/contexts/FEEL"

      click_on 'Your Recent Moods & Emotions'
      expect(page).to have_content 'Positive and Negative Emotions'

      within('.dropdown-toggle', text: 'FEEL') do
        expect(page).to_not have_content 'New!'
      end
    end
  end
end
