# filename: do1_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Do - Participant 1', type: :feature, sauce: sauce_labs do
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

  # define methods for this spec file
  def choose_rating(element_id, value)
    find("##{ element_id } select").find(:xpath, "option[#{(value + 1)}]").select_option
  end

  # tests
  # Testing the #1 Awareness portion of the DO tool
  it '- awareness' do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Continue'
    expect(page).to have_content "OK, let's talk about yesterday."

    yesterday = Date.today.prev_day
    select yesterday.strftime('%a') + ' 7 AM', from: 'awake_period_start_time'
    select yesterday.strftime('%a') + ' 10 PM', from: 'awake_period_end_time'
    click_on 'Create'
    expect(page).to have_content 'Awake Period saved'

    fill_in 'activity_type_0', with: 'Get ready for work'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 7)
    fill_in 'activity_type_1', with: 'Travel to work'
    choose_rating('pleasure_1', 3)
    choose_rating('accomplishment_1', 5)
    fill_in 'activity_type_2', with: 'Work'
    choose_rating('pleasure_2', 5)
    choose_rating('accomplishment_2', 8)
    click_on 'copy_3'
    click_on 'copy_4'
    click_on 'copy_5'
    click_on 'copy_6'
    click_on 'copy_7'
    click_on 'copy_8'
    click_on 'copy_9'
    fill_in 'activity_type_10', with: 'Travel from work'
    choose_rating('pleasure_10', 5)
    choose_rating('accomplishment_10', 8)
    fill_in 'activity_type_11', with: 'eat dinner'
    choose_rating('pleasure_11', 8)
    choose_rating('accomplishment_11', 8)
    fill_in 'activity_type_12', with: 'Watch TV'
    choose_rating('pleasure_12', 9)
    choose_rating('accomplishment_12', 3)
    click_on 'copy_13'
    fill_in 'activity_type_14', with: 'Get ready for bed'
    choose_rating('pleasure_14', 2)
    choose_rating('accomplishment_14', 3)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

    click_on 'Continue'
    expect(page).to have_content 'Things you found fun.'

    click_on 'Continue'
    expect(page).to have_content "Things that make you feel like you've accomplished something."

    click_on 'Continue'
    expect(page).to have_content 'Add a New Activity'
  end

  # Testing that previously entered and completed wake period is not available
  it '- awareness, already entered wake period' do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Continue'
    expect(page).to have_content "OK, let's talk about yesterday."

    yesterday = Date.today.prev_day
    expect { select yesterday.strftime('%a') + ' 7 AM', from: 'awake_period_start_time' }.to raise_error

    expect { select yesterday.strftime('%a') + ' 10 PM', from: 'awake_period_end_time' }.to raise_error
  end

  # Testing the #1 Awareness portion of the DO tool
  it '- awareness second time around' do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Continue'
    expect(page).to have_content "OK, let's talk about yesterday."

    today = Date.today
    select today.strftime('%a') + ' 2 AM', from: 'awake_period_start_time'
    select today.strftime('%a') + ' 3 AM', from: 'awake_period_end_time'
    click_on 'Create'
    expect(page).to have_content 'Awake Period saved'

    fill_in 'activity_type_0', with: 'Sleep'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 1)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

    click_on 'Continue'
    expect(page).to have_content 'Things you found fun.'

    click_on 'Continue'
    expect(page).to have_content "Things that make you feel like you've accomplished something."

    click_on 'Continue'
    expect(page).to have_content 'Add a New Activity'
  end

  # Testing the #2-Planning of the DO tool
  # this test passes because I do not select a time in the "future_time_picker_0" - this is likely going to be updated
  # I will update this test when that is completed
  it '- planning' do
    click_on '#2 Planning'
    expect(page).to have_content 'The last few times you were here...'

    click_on 'Continue'
    expect(page).to have_content 'We want you to plan one fun thing'

    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 3)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'
    expect(page).to have_content 'Now, plan something that gives you a sense of accomplishment.'
    fill_in 'activity_activity_type_new_title', with: 'Another planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 4)
    choose_rating('accomplishment_0', 8)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'OK... the most important thing is to do more that is pleasureable and gives you a sense of accomplishment'

    click_on 'Continue'
    expect(page).to have_content 'Your Planned Activities'

    click_on 'Continue'
    expect(page).to have_content 'Upcoming Activities'
  end

  # Testing the #3-Reviewing section of the DO tool
  it '- reviewing' do
    click_on '#3 Doing'
    expect(page).to have_content 'Welcome back!'

    click_on 'Continue'
    expect(page).to have_content "Let's do this..."

    click_on 'Continue'
    find(:xpath, '(/html/body/div[1]/div[1]/div/div[3]/form[1]/div[2]/label[1])').click
    select '7', from: 'activity[actual_pleasure_intensity]'
    select '5', from: 'activity[actual_accomplishment_intensity]'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'New planned activity'

    find(:xpath, '(/html/body/div[1]/div[1]/div/div[3]/form[2]/div[2]/label[2])').click
    fill_in 'activity[noncompliance_reason]', with: "I didn't have time"
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Another planned activity'

    find(:xpath, '(/html/body/div[1]/div[1]/div/div[3]/form[3]/div[2]/label[1])').click
    select '2', from: 'activity[actual_pleasure_intensity]'
    select '8', from: 'activity[actual_accomplishment_intensity]'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Add a New Activity'

    visit ENV['Base_URL']
    find(:xpath, '//*[@id="SocialNetworking::SharedItem-809335061"]/div[2]/button[5]/i').click
    expect(page).to have_content 'actual accomplishment: 5'

    expect(page).to have_content 'actual pleasure: 7'
  end

  # Testing Plan a New Activity portion of the DO tool
  it '- plan a new activity' do
    click_on 'Add a New Activity'
    expect(page).to have_content "But you don't have to start from scratch,"

    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 4)
    choose_rating('accomplishment_0', 3)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Add a New Activity'
  end

  # Testing Your Activities portion of the DO tool
  it '- your activities' do
    click_on 'Your Activities'
    expect(page).to have_content 'Today'

    today = Date.today
    expect(page).to have_content 'Daily Averages for ' + today.strftime('%b %e, %Y')

    click_on 'Daily Summaries'
    expect(page).to have_content 'Average Accomplishment Discrepancy'

    find(:xpath, 'html/body/div[1]/div[1]/div/div[3]/div[5]/div[2]/div[3]/div[1]/h4/a').click
    expect(page).to have_content 'Predicted'

    click_on 'Edit'
    expect(page).to have_css('#activity_actual_accomplishment_intensity')

    click_on 'Previous Day'
    yesterday = today - 1
    expect(page).to have_content 'Daily Averages for ' + yesterday.strftime('%b %e, %Y')

    click_on 'Next Day'
    expect(page).to have_content 'Daily Averages for ' + today.strftime('%b %e, %Y')

    click_on 'Visualize'
    click_on 'Last 3 Days'
    expect(page).to have_content today.strftime('%A, %m/%e')

    click_on 'Day'
    expect(page).to have_css('#datepicker')
  end

  # Testing the navbar functionality specifically surrounding the DO tool
  it '- navbar functionality' do
    visit ENV['Base_URL'] + '/navigator/modules/339588004'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'DO'
    click_on '#2 Planning'
    expect(page).to have_content 'The last few times you were here...'

    click_on 'DO'
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'DO'
    click_on '#3 Doing'
    expect(page).to have_content 'Welcome back!'

    click_on 'DO'
    click_on 'Add a New Activity'
    expect(page).to have_content "But you don't have to start from scratch,"

    click_on 'DO'
    click_on 'Your Activities'
    expect(page).to have_content 'Today'

    click_on 'DO'
    click_on 'DO Home'
    expect(page).to have_content 'Add a New Activity'
  end

  # Testing the skip functionality in the slideshow portions of the first three parts of the DO tool
  it '- skip functionality' do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Skip'
    expect(page).to have_content "OK, let's talk about yesterday."

    click_on 'DO'
    click_on '#2 Planning'
    expect(page).to have_content 'The last few times you were here...'

    click_on 'Skip'
    expect(page).to have_content 'We want you to plan one fun thing'

    click_on 'DO'
    click_on '#3 Doing'
    expect(page).to have_content 'Welcome back!'

    click_on 'Skip'

    if page.has_text?('You said you were going to')
      expect(page).to have_content 'You said you were going to'

    else
      expect(page).to have_content "It doesn't look like there are any activities for you to review at this time"
    end
  end

  # Testing the DO tool visualization
  it '- visualization' do
    expect(page).to have_content 'Activities in your near future'
  end
end

describe 'Do - Participant 3', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Alt_Participant_Email']
      fill_in 'participant_password', with: ENV['Alt_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Your Activities'
  end

  # define methods for this spec file
  def choose_rating(element_id, value)
    find("##{ element_id } select").find(:xpath, "option[#{(value + 1)}]").select_option
  end

  # tests
  # Testing the #1 Awareness portion of the DO tool
  it '- awareness with already entered but not completed awake period' do
    click_on '#1 Awareness'
    expect(page).to have_content 'This is just the beginning...'

    click_on 'Continue'
    expect(page).to have_content "OK, let's talk about yesterday."

    expect(page).to have_content 'Last Recorded Awake Period:'

    click_on 'Complete'
    expect(page).to have_content 'Review Your Day'

    fill_in 'activity_type_0', with: 'Get ready for work'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 7)
    fill_in 'activity_type_1', with: 'Travel to work'
    choose_rating('pleasure_1', 2)
    choose_rating('accomplishment_1', 3)
    fill_in 'activity_type_2', with: 'Work'
    choose_rating('pleasure_2', 8)
    choose_rating('accomplishment_2', 9)
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Take a look - does this all seem right? Recently, you...'

    click_on 'Continue'
    expect(page).to have_content 'Things you found fun.'

    click_on 'Continue'
    expect(page).to have_content "Things that make you feel like you've accomplished something."

    click_on 'Continue'
    expect(page).to have_content 'Your Activities'
  end

  it '- visualization' do
    expect(page).to have_content 'Recent Past Activities'

    click_on 'Edit'
    expect(page).to have_content 'You said you were going to'
  end
end