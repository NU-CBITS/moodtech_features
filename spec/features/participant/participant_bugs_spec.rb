# filename: participant_bugs_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# define methods for this spec file
def choose_rating(element_id, value)
  find("##{ element_id } select").find(:xpath, "option[#{(value + 1)}]").select_option
end

# tests
describe 'Participant Bugs', type: :feature, sauce: sauce_labs do
  context 'Participant 1 signs in, navigates to the DO tool,' do
    before(:each) do
      visit ENV['Base_URL'] + '/participants/sign_in'
      within('#new_participant') do
        fill_in 'participant_email', with: ENV['Participant_Email']
        fill_in 'participant_password', with: ENV['Participant_Password']
      end

      click_on 'Sign in'
      expect(page).to have_content 'Signed in successfully'

      visit ENV['Base_URL'] + '/navigator/contexts/DO'
      expect(page).to have_content 'Add a New Activity'
    end

    it 'completes Planning without receiving multiple alerts' do
      click_on '#2 Planning'
      expect(page).to have_content 'The last few times you were here...'

      click_on 'Next'
      expect(page).to have_content 'We want you to plan one fun thing'

      fill_in 'activity_activity_type_new_title', with: 'New planned activity'
      today = Date.today
      tomorrow = today + 1
      fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Now, plan something that gives you a sense of accomplishment.'

      fill_in 'activity_activity_type_new_title', with: 'Another planned activity'
      today = Date.today
      tomorrow = today + 1
      fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 8)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'OK... the most important thing is to do more that is pleasureable and gives you a sense of accomplishment'

      click_on 'Next'
      expect(page).to have_content 'Your Planned Activities'

      click_on 'Next'
      expect(page).to have_content 'Upcoming Activities'
    end

    it 'completes Plan a New Activity without multiple alerts' do
      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      fill_in 'activity_activity_type_new_title', with: 'New planned activity'
      today = Date.today
      tomorrow = today + 1
      fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Add a New Activity'
    end

    it 'visits Your Activities and selects Previous Day without receiving exception' do
      click_on '#1 Awareness'
      expect(page).to have_content 'This is just the beginning...'

      click_on 'Next'
      expect(page).to have_content "OK, let's talk about yesterday."

      today = Date.today
      select today.strftime('%a') + ' 2 AM', from: 'awake_period_start_time'
      select today.strftime('%a') + ' 3 AM', from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      fill_in 'activity_type_0', with: 'Sleep'
      choose_rating('pleasure_0', 9)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

      click_on 'Next'
      expect(page).to have_content 'Things you found fun.'

      click_on 'Next'
      expect(page).to have_content "Things that make you feel like you've accomplished something."

      click_on 'Next'
      expect(page).to have_content 'Add a New Activity'

      click_on 'Your Activities'
      expect(page).to have_content 'Today'

      click_on 'Previous Day'
      yesterday = today - 1
      expect(page).to have_content 'Daily Averages for ' + yesterday.strftime('%b %d, %Y')
    end

    it 'completes Awareness and finds the activity properly displayed on feed' do
      click_on '#1 Awareness'
      expect(page).to have_content 'This is just the beginning...'

      click_on 'Next'
      expect(page).to have_content "OK, let's talk about yesterday."

      today = Date.today
      select today.strftime('%a') + ' 4 AM', from: 'awake_period_start_time'
      select today.strftime('%a') + ' 5 AM', from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      fill_in 'activity_type_0', with: 'doing whatever thing'
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 7)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

      click_on 'Next'
      expect(page).to have_content 'Things you found fun.'

      click_on 'Next'
      expect(page).to have_content "Things that make you feel like you've accomplished something."

      click_on 'Next'
      expect(page).to have_content 'Add a New Activity'

      visit ENV['Base_URL']
      within('.list-group-item.ng-scope', text: 'monitored an Activity: doing whatever thing') do
        within('.actions') do
          find('.fa.fa-folder-open.fa-2x.ng-scope').click
        end
        expect(page).to have_content 'actual accomplishment: 7'

        expect(page).to have_content 'actual pleasure: 6'
      end
    end
  end

  context 'Participant 2 signs in,' do
    before(:each) do
      visit ENV['Base_URL'] + '/participants/sign_in'
      within('#new_participant') do
        fill_in 'participant_email', with: ENV['Participant_2_Email']
        fill_in 'participant_password', with: ENV['Participant_2_Password']
      end

      click_on 'Sign in'
      expect(page).to have_content 'Signed in successfully'
    end

    it 'navigates to a module from the dropdown, completes the module, the module appears complete on landing page' do
      within('.dropdown-toggle', text: 'FEEL') do
        expect(page).to have_content 'New!'
      end

      find('.dropdown-toggle', text: 'FEEL').click
      within('.dropdown-menu') do
        click_on 'Tracking Your Mood & Emotions'
      end

      expect(page).to have_content 'Rate your Mood'

      select '6', from: 'mood[rating]'
      click_on 'Next'
      expect(page).to have_content 'Mood saved'

      expect(page).to have_content 'You just rated your mood as a 6 (Good)'

      expect(page).to have_content 'Rate your Emotions'

      select 'anxious', from: 'emotional_rating_emotion_id'
      select 'negative', from: 'emotional_rating_is_positive'
      select '4', from: 'emotional_rating[rating]'

      click_on 'Next'
      expect(page).to have_content 'Emotional Rating saved'

      click_on 'Next'
      expect(page).to have_content 'Feeling Tracker Landing'

      click_on 'Your Recent Moods & Emotions'
      expect(page).to have_content 'Positive and Negative Emotions'

      click_on 'Next'
      expect(page).to have_content 'Feeling Tracker Landing'

      within('.dropdown-toggle', text: 'FEEL') do
        expect(page).to_not have_content 'New!'
      end
    end
  end
end
