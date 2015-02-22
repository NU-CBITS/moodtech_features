# filename: shared_items_spec.rb

require_relative '../../../../spec/spec_helper'
require_relative '../../../../spec/configure_cloud'

# define methods for this spec file
def choose_rating(element_id, value)
  find("##{ element_id } select").find(:xpath, "option[#{(value + 1)}]").select_option
end

describe 'Active participant in a social arm is signed in,', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content "What's on your mind?"
  end

  # Testing shared items created from the #1-Identifying portion of the THINK tool
  it 'shares THINK - Identifying responses' do
    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'Add a New Thought'

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

    fill_in 'thought_content', with: 'Public thought 2'
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Good work'

    click_on 'Next'
    expect(page).to have_content 'Add a New Thought'

    visit ENV['Base_URL']
    expect(page).to_not have_content 'Private thought'

    expect(page).to have_content 'Public thought 1'

    expect(page).to have_content 'Public thought 2'
  end

  # Testing shared items from the Add a New Thought portion of the THINK tool
  it 'shares Add a New Thought responses' do
    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'Add a New Thought'

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
    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'Add a New Thought'

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

  # Testing shared items from the #1 Awareness portion of the DO tool
  it 'shares DO > Awareness responses' do
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Next'
    expect(page).to have_content "OK, let's talk about yesterday."

    today = Date.today
    select today.strftime('%a') + ' 4 AM', from: 'awake_period_start_time'
    select today.strftime('%a') + ' 7 AM', from: 'awake_period_end_time'
    click_on 'Create'
    expect(page).to have_content 'Awake Period saved'

    expect(page).to have_content 'Review Your Day'

    fill_in 'activity_type_0', with: 'public sleep 1'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 7)
    fill_in 'activity_type_1', with: 'private sleep'
    choose_rating('pleasure_1', 2)
    choose_rating('accomplishment_1', 3)
    find(:xpath, '//*[@id="past_activities_container"]/form[2]/span/div/label[3]').click
    fill_in 'activity_type_2', with: 'public sleep 2'
    choose_rating('pleasure_2', 8)
    choose_rating('accomplishment_2', 9)
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

    click_on 'Next'
    expect(page).to have_content 'Things you found fun.'

    click_on 'Next'
    expect(page).to have_content "Things that make you feel like you've accomplished something."

    click_on 'Next'
    expect(page).to have_content 'Your Activities'

    visit ENV['Base_URL']
    expect(page).to_not have_content 'private sleep'

    expect(page).to have_content 'public sleep 1'

    expect(page).to have_content 'public sleep 2'
  end

  # Testing shared items from the #2-Planning of the DO tool
  it 'shares DO > Planning responses' do
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on '#2 Planning'
    expect(page).to have_content 'The last few times you were here...'

    click_on 'Next'
    expect(page).to have_content 'We want you to plan one fun thing'

    fill_in 'activity_activity_type_new_title', with: 'New public activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 3)
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Now, plan something that gives you a sense of accomplishment.'

    fill_in 'activity_activity_type_new_title', with: 'New private activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 4)
    choose_rating('accomplishment_0', 8)
    choose 'No'
    click_on 'Next'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'OK... the most important thing is to do more that is pleasureable and gives you a sense of accomplishment'

    click_on 'Next'
    expect(page).to have_content 'Your Planned Activities'

    click_on 'Next'
    expect(page).to have_content 'Upcoming Activities'

    visit ENV['Base_URL']
    expect(page).to_not have_content 'New private activity'

    expect(page).to have_content 'New public activity'
  end

  # Testing shared items from Plan a New Activity portion of the DO tool
  it 'shares Add a New Activity responses' do
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on 'Add a New Activity'
    expect(page).to have_content "But you don't have to start from scratch,"

    fill_in 'activity_activity_type_new_title', with: 'New public activity 2'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
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
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on 'Add a New Activity'
    expect(page).to have_content "But you don't have to start from scratch,"

    fill_in 'activity_activity_type_new_title', with: 'New private activity 2'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
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

describe 'Active participant in a non-social arm is signed in,', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['NS_Participant_Email']
      fill_in 'participant_password', with: ENV['NS_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to_not have_content "What's on your mind?"
  end

  context 'is not able to create a shared item' do
    it 'in THINK > Identifying' do
      visit ENV['Base_URL'] + '/navigator/contexts/THINK'
      expect(page).to have_content 'Add a New Thought'

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

    it 'in THINK > Add a New Thought' do
      visit ENV['Base_URL'] + '/navigator/contexts/THINK'
      expect(page).to have_content 'Add a New Thought'

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

    it 'in DO > Awareness' do
      visit ENV['Base_URL'] + '/navigator/contexts/DO'
      expect(page).to have_content 'Add a New Activity'

      click_on '#1 Awareness'
      expect(page).to have_content 'This is just the beginning...'

      click_on 'Next'
      expect(page).to have_content "OK, let's talk about yesterday."

      today = Date.today
      select today.strftime('%a') + ' 4 AM', from: 'awake_period_start_time'
      select today.strftime('%a') + ' 7 AM', from: 'awake_period_end_time'
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

      expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'
    end

    it 'in DO > Planning' do
      visit ENV['Base_URL'] + '/navigator/contexts/DO'
      expect(page).to have_content 'Add a New Activity'

      click_on '#2 Planning'
      expect(page).to have_content 'The last few times you were here...'

      click_on 'Next'
      expect(page).to have_content 'We want you to plan one fun thing'

      expect(page).to_not have_content 'Share the content of this activity?'

      fill_in 'activity_activity_type_new_title', with: 'New public activity'
      today = Date.today
      tomorrow = today + 1
      fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 6)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      expect(page).to have_content 'Activity saved'
    end

    it 'in DO > Plan a New Activity' do
      visit ENV['Base_URL'] + '/navigator/contexts/DO'
      expect(page).to have_content 'Add a New Activity'

      click_on 'Add a New Activity'
      expect(page).to have_content "But you don't have to start from scratch,"

      expect(page).to_not have_content 'Share the content of this activity?'

      fill_in 'activity_activity_type_new_title', with: 'New public activity 2'
      today = Date.today
      tomorrow = today + 1
      fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
      choose_rating('pleasure_0', 4)
      choose_rating('accomplishment_0', 3)
      click_on 'Next'
      expect(page).to have_content 'Activity saved'

      expect(page).to have_content 'Add a New Activity'
    end
  end
end
