# filename: shared_items_spec.rb

describe 'Active participant in a social arm is signs in,',
         type: :feature, sauce: sauce_labs do
  context 'visits the THINK tool,' do
    before(:each) do
      sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

      expect(page).to have_content "What's on your mind?"

      visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
      expect(page).to have_content 'Add a New Thought'
    end

    it 'shares THINK > Identifying responses' do
      click_on '#1 Identifying'
      expect(page).to have_content 'You are what you think...'

      click_on 'Skip'
      expect(page).to have_content 'Now, your turn...'

      fill_in 'thought_content', with: 'Public thought 1'
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Thought saved'

      expect(page).to have_content 'Now list another harmful thought...'

      fill_in 'thought_content', with: 'Private thought 1'
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Thought saved'

      expect(page).to have_content 'Just one more'

      visit ENV['Base_URL']
      expect(page).to_not have_content 'Private thought'

      expect(page).to have_content 'Public thought 1'
    end

    it 'shares Add a New Thought responses' do
      click_on 'Add a New Thought'
      expect(page).to have_content 'Add a New Harmful Thought'

      fill_in 'thought_content', with: 'Public thought 3'
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
      fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
      fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Thought saved'

      click_on 'Next'
      expect(page).to have_content 'Add a New Thought'

      visit ENV['Base_URL']
      expect(page).to have_content 'Public thought 3'
    end

    it 'does not share Add a New Thought responses' do
      click_on 'Add a New Thought'
      expect(page).to have_content 'Add a New Harmful Thought'

      fill_in 'thought_content', with: 'Private thought 2'
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
      fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
      fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Thought saved'

      click_on 'Next'
      expect(page).to have_content 'Add a New Thought'

      visit ENV['Base_URL']
      expect(page).to_not have_content 'Private thought 2'
    end
  end

  context 'visits the DO tool,' do
    before(:each) do
      sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

      expect(page).to have_content "What's on your mind?"

      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
      expect(page).to have_content 'Add a New Activity'
    end

    it 'shares DO > Awareness responses' do
      click_on '#1 Awareness'
      expect(page).to have_content 'This is just the beginning...'

      click_on 'Next'
      expect(page).to have_content "OK, let's talk about yesterday."

      select "#{Date.today.strftime('%a')} 6 AM",
             from: 'awake_period_start_time'
      select "#{Date.today.strftime('%a')} 8 AM", from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      expect(page).to have_content 'Review Your Day'

      fill_in 'activity_type_0', with: 'public sleep 1'
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 7)

      fill_in 'activity_type_1', with: 'private sleep'
      choose_rating('pleasure_1', 2)
      choose_rating('accomplishment_1', 3)
      shareable_form = page.all('.new-shareable-form-after-form-groups')
      within shareable_form[1] do
        choose 'No'
      end

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
      expect(page).to have_content 'Your Activities'

      visit ENV['Base_URL']
      expect(page).to_not have_content 'private sleep'

      expect(page).to have_content 'public sleep 1'
    end

    it 'shares DO > Planning responses' do
      click_on '#2 Planning'
      expect(page).to have_content 'The last few times you were here...'

      click_on 'Next'
      expect(page).to have_content 'We want you to plan one fun thing'

      fill_in 'activity_activity_type_new_title', with: 'New public activity'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Now, plan something that gives you a ' \
                                   'sense of accomplishment.'

      fill_in 'activity_activity_type_new_title', with: 'New private activity'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 8)
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'OK... the most important thing is to do ' \
                                   'more that is pleasureable and gives you ' \
                                   'a sense of accomplishment'

      click_on 'Next'
      expect(page).to have_content 'Your Planned Activities'

      click_on 'Next'
      expect(page).to have_content 'Upcoming Activities'

      visit ENV['Base_URL']
      expect(page).to_not have_content 'New private activity'

      expect(page).to have_content 'New public activity'
    end

    it 'shares Add a New Activity responses' do
      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      fill_in 'activity_activity_type_new_title', with: 'New public activity 2'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      page.accept_alert 'Are you sure that you would like to make these public?'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Add a New Activity'

      visit ENV['Base_URL']
      expect(page).to have_content 'New public activity 2'
    end

    it 'does not share Add a New Activity responses' do
      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      fill_in 'activity_activity_type_new_title', with: 'New private activity 2'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      choose 'No'
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Add a New Activity'

      visit ENV['Base_URL']
      expect(page).to_not have_content 'New private activity 2'
    end
  end
end

describe 'Active participant in a non-social arm is signs in,',
         type: :feature, sauce: sauce_labs do
  context 'visits the THINK tool,' do
    before(:each) do
      sign_in_pt(ENV['NS_Participant_Email'], ENV['NS_Participant_Password'])

      expect(page).to_not have_content "What's on your mind?"

      visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
      expect(page).to have_content 'Add a New Thought'
    end

    it 'is not able to create a shared item in Identifying' do
      click_on '#1 Identifying'
      expect(page).to have_content 'You are what you think...'

      click_on 'Next'
      expect(page).to have_content 'Helpful thoughts are...'

      click_on 'Next'
      expect(page).to have_content 'Harmful thoughts are:'

      click_on 'Next'
      expect(page).to have_content 'Some quick examples...'

      click_on 'Next'
      expect(page).to have_content 'Now, your turn...'

      expect(page).to_not have_content 'Share the content of this thought?'

      fill_in 'thought_content', with: 'Test thought 1'
      click_on 'Next'

      expect(page).to have_content 'Now list another harmful thought...'
    end

    it 'is not able to create a shared item in Add a New Thought' do
      click_on 'Add a New Thought'
      expect(page).to have_content 'Add a New Harmful Thought'

      expect(page).to_not have_content 'Share the content of this thought?'

      fill_in 'thought_content', with: 'Public thought 3'
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
      fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
      fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
      click_on 'Next'
      expect(page).to have_content 'Thought saved'

      click_on 'Next'
      expect(page).to have_content 'Add a New Thought'
    end
  end

  context 'visits the DO tool,' do
    before(:each) do
      sign_in_pt(ENV['NS_Participant_Email'], ENV['NS_Participant_Password'])

      expect(page).to_not have_content "What's on your mind?"

      visit "#{ENV['Base_URL']}/navigator/contexts/DO"
      expect(page).to have_content 'Add a New Activity'
    end

    it 'is not able to create a shared item in Awareness' do
      click_on '#1 Awareness'
      expect(page).to have_content 'This is just the beginning...'

      click_on 'Next'
      expect(page).to have_content "OK, let's talk about yesterday."

      select "#{Date.today.strftime('%a')} 4 AM",
             from: 'awake_period_start_time'
      select "#{Date.today.strftime('%a')} 7 AM", from: 'awake_period_end_time'
      click_on 'Create'
      expect(page).to have_content 'Awake Period saved'

      expect(page).to have_content 'Review Your Day'

      expect(page).to_not have_content 'Share the content of this activity?'

      fill_in 'activity_type_0', with: 'public sleep 1'
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 7)
      fill_in 'activity_type_1', with: 'private sleep'
      choose_rating('pleasure_1', 2)
      choose_rating('accomplishment_1', 3)
      fill_in 'activity_type_2', with: 'public sleep 2'
      choose_rating('pleasure_2', 8)
      choose_rating('accomplishment_2', 9)
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Take a look - does this all seem right? ' \
                                   'Recently, you...'
    end

    it 'is not able to create a shared item in Planning' do
      click_on '#2 Planning'
      expect(page).to have_content 'The last few times you were here...'

      click_on 'Next'
      expect(page).to have_content 'We want you to plan one fun thing'

      expect(page).to_not have_content 'Share the content of this activity?'

      fill_in 'activity_activity_type_new_title', with: 'New public activity'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      expect(page).to have_content 'Activity saved'
    end

    it 'is not able to create a shared item in Plan a New Activity' do
      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      expect(page).to_not have_content 'Share the content of this activity?'

      fill_in 'activity_activity_type_new_title', with: 'New public activity 2'
      fill_in 'future_date_picker_0',
              with: Date.today.next_day.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Add a New Activity'
    end
  end
end
