# filename: do1_spec.rb

describe 'Active participant in group 1 signs in, navigates to DO tool,',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_pt(ENV['Participant_Email'], 'participant1',
                 ENV['Participant_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_pt(ENV['Participant_Email'], 'participant1',
                 ENV['Participant_Password'])
    end

    visit "#{ENV['Base_URL']}/navigator/contexts/DO"
  end

  it 'completes Awareness' do
    click_on '#1 Awareness'
    click_on 'Next'
    select "#{Date.today.prev_day.strftime('%a')} 7 AM",
           from: 'awake_period_start_time'
    select "#{Date.today.prev_day.strftime('%a')} 10 PM",
           from: 'awake_period_end_time'
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
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'copy_3'
    click_on 'copy_4'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'copy_5'
    click_on 'copy_6'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'copy_7'
    click_on 'copy_8'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'copy_9'
    fill_in 'activity_type_10', with: 'Travel from work'
    choose_rating('pleasure_10', 5)
    choose_rating('accomplishment_10', 8)
    page.execute_script('window.scrollTo(0,5000)')
    fill_in 'activity_type_11', with: 'eat dinner'
    choose_rating('pleasure_11', 8)
    choose_rating('accomplishment_11', 8)
    fill_in 'activity_type_12', with: 'Watch TV'
    choose_rating('pleasure_12', 9)
    choose_rating('accomplishment_12', 3)
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'copy_13'
    fill_in 'activity_type_14', with: 'Get ready for bed'
    choose_rating('pleasure_14', 2)
    choose_rating('accomplishment_14', 3)
    page.execute_script('window.scrollTo(0,5000)')
    accept_social
    expect(page).to have_content 'Take a look'
    page.execute_script('window.scrollTo(0,5000)')
    within('#recent_activities') do
      expect(page).to have_css('tr', count: '17')
    end

    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Next'
    within('#fun_activities') do
      expect(page).to have_css('tr', count: '4')
    end

    click_on 'Next'
    within('#accomplished_activities') do
      expect(page).to have_css('tr', count: '5')
    end

    click_on 'Next'
    find('h1', text: 'Do Landing')
    visit ENV['Base_URL']
    find_feed_item('Monitored an Activity: Get ready for bed')
    activity = page.all('.list-group-item.ng-scope',
                        text: 'Monitored an Activity: Get ready for bed')
    within activity[0] do
      click_on 'More'
      yesterday = Date.today - 1
      expect(page).to have_content 'start: ' \
                                   "#{yesterday.strftime('%b. %-d, %Y')}" \
                                   " at 9:00PM\nend: " \
                                   "#{yesterday.strftime('%b. %-d, %Y')}" \
                                   " at 10:00PM actual accomplishment: 3\n" \
                                   'actual pleasure: 2'
    end
  end

  it 'cannot complete Awareness for a time period already completed' do
    click_on '#1 Awareness'
    click_on 'Next'
    within('#awake_period_start_time') do
      expect(page).to_not have_content "#{Date.today.prev_day.strftime('%a')}" \
                                       ' 7 AM'
    end

    within('#awake_period_end_time') do
      expect(page).to_not have_content "#{Date.today.prev_day.strftime('%a')}" \
                                       ' 10 PM'
    end
  end

  it 'completes Awareness for different time on same day that overlaps days' do
    click_on '#1 Awareness'
    click_on 'Next'
    select "#{Date.today.prev_day.strftime('%a')} 11 PM",
           from: 'awake_period_start_time'
    select "#{Date.today.strftime('%a')} 1 AM", from: 'awake_period_end_time'
    click_on 'Create'
    expect(page).to have_content 'Awake Period saved'

    fill_in 'activity_type_0', with: 'Sleep'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 1)
    click_on 'copy_1'
    page.execute_script('window.scrollTo(0,5000)')
    accept_social
    find('#recent_activities')
    click_on 'Next'
    find('#fun_activities')
    click_on 'Next'
    find('#accomplished_activities')
    click_on 'Next'
    find('h1', text: 'Do Landing')
  end

  it 'completes Planning' do
    click_on '#2 Planning'
    click_on 'Next'
    find('#new_activity_radio').click
    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    page.execute_script('window.scrollTo(0,5000)')
    find('.fa.fa-calendar').click
    pick_tomorrow
    select '6', from: 'planned_activity[predicted_pleasure_intensity]'
    select '3', from: 'planned_activity[predicted_accomplishment_intensity]'
    accept_social
    expect(page).to have_content 'Activity saved'

    page.execute_script('window.scrollTo(0,5000)')
    find('#new_activity_radio').click
    fill_in 'activity_activity_type_new_title', with: 'Another planned activity'
    page.execute_script('window.scrollTo(0,5000)')
    find('.fa.fa-calendar').click
    pick_tomorrow
    select '4', from: 'planned_activity[predicted_pleasure_intensity]'
    select '8', from: 'planned_activity[predicted_accomplishment_intensity]'
    accept_social
    find('h1', text: 'OK...')
    click_on 'Next'
    within('#previous_activities') do
      expect(page).to have_css('tr', count: '6')
    end

    click_on 'Next'
    find('h1', text: 'Do Landing')
    visit ENV['Base_URL']
    find_feed_item('Planned an Activity: New planned activity')
    within('.list-group-item.ng-scope',
           text: 'Planned an Activity: New planned activity') do
      click_on 'More'
      time1 = Time.now + (60 * 60 * 25)
      time2 = Time.now + (60 * 60 * 26)
      expect(page)
        .to have_content "start: #{time1.strftime('%b. %-d, %Y at %-l')}"

      expect(page)
        .to have_content "end: #{time2.strftime('%b. %-d, %Y at %-l')}"

      expect(page).to have_content "predicted accomplishment: 3\npredicted " \
                                   'pleasure: 6'
    end
  end

  it 'completes Reviewing' do
    click_on '#3 Doing'
    click_on 'Next'
    expect(page).to have_content "Let's do this..."

    click_on 'Next'
    find('.btn.btn-success').click
    select '7', from: 'activity[actual_pleasure_intensity]'
    select '5', from: 'activity[actual_accomplishment_intensity]'
    accept_social
    expect(page).to have_content 'Activity saved'

    if page.has_text?('You said you were going to')
      find('.btn.btn-danger').click
      fill_in 'activity[noncompliance_reason]', with: "I didn't have time"
      accept_social
      expect(page).to have_content 'Activity saved'
    end

    visit ENV['Base_URL']
    find_feed_item('Reviewed & Completed an Activity: Parkour')
    within('.list-group-item.ng-scope',
           text: 'Reviewed & Completed an Activity: Parkour') do
      click_on 'More'
      time1 = Time.now - (60 * 60 * 24)
      time2 = Time.now - (60 * 60 * 23)
      expect(page)
        .to have_content "start: #{time1.strftime('%b. %-d, %Y at %-l')}"

      expect(page)
        .to have_content "end: #{time2.strftime('%b. %-d, %Y at %-l')}"

      expect(page)
        .to have_content "predicted accomplishment: 4\npredicted pleasure: " \
                         "9\nactual accomplishment: 5\nactual pleasure: 7"
    end

    within('.list-group-item.ng-scope',
           text: 'Reviewed and did not complete an Activity: Loving') do
      click_on 'More'

      expect(page).to_not have_content 'actual accomplishment:'
    end
  end

  it 'completes Plan a New Activity' do
    click_on 'Add a New Activity'
    find('#new_activity_radio').click
    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    page.execute_script('window.scrollTo(0,5000)')
    find('.fa.fa-calendar').click
    pick_tomorrow
    select '4', from: 'planned_activity[predicted_pleasure_intensity]'
    select '3', from: 'planned_activity[predicted_accomplishment_intensity]'
    accept_social
    expect(page).to have_content 'Activity saved'
  end

  it 'uses Your Activities viz' do
    click_on 'Your Activities'
    expect(page).to have_content 'Daily Averages for ' \
                                 "#{Date.today.strftime('%b %d %Y')}"

    expect(page).to have_content 'Average Accomplishment Discrepancy'

    click_on 'Daily Summaries'
    expect(page).to_not have_content 'Average Accomplishment Discrepancy'

    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Previous Day'
    expect(page).to have_content 'Daily Averages for ' \
                                 "#{Date.today.prev_day.strftime('%b %d %Y')}"

    page.execute_script('window.scrollTo(0,5000)')
    endtime = Time.now + (60 * 60)
    within('.panel.panel-default',
           text: "#{Time.now.strftime('%-l %P')} - " \
           "#{endtime.strftime('%-l %P')}: Parkour") do
      click_on "#{Time.now.strftime('%-l %P')} - " \
               "#{endtime.strftime('%-l %P')}: Parkour"
      expect(page).to have_content 'Predicted  Average Importance: 4 Really ' \
                                   'fun: 9'

      within('.collapse.in') do
        click_on 'Edit'
        expect(page).to have_css('#activity_actual_accomplishment_intensity')
      end
    end

    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Next Day'
    expect(page).to have_content 'Daily Averages for ' \
                                 "#{Date.today.strftime('%b %d %Y')}"

    click_on 'Visualize'
    click_on 'Last 3 Days'
    date1 = Date.today - 2
    expect(page).to have_content date1.strftime('%A, %m/%d')

    click_on 'Day'
    expect(page).to have_css('#datepicker')
  end

  it 'visits View Planned Activities' do
    click_on 'View Planned Activities'
    find('.text-capitalize', text: 'View Planned Activities')
    expect(page).to have_content 'Speech'
  end

  it 'uses navbar functionality for all of DO' do
    visit "#{ENV['Base_URL']}/navigator/modules/339588004"
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
    click_on 'View Planned Activities'
    expect(page).to have_content 'Speech'

    click_on 'DO'
    click_on 'DO Home'
    expect(page).to have_content 'Add a New Activity'
  end

  it 'uses skip functionality in all of DO slideshows' do
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
    unless page.has_text?('You said you were going to')
      expect(page).to have_content "It doesn't look like there are any " \
                                   'activities for you to review at this time'
    end
  end

  it 'sees Upcoming Activities on DO > Landing' do
    expect(page).to have_content 'Activities in your near future'
  end
end

describe 'Active participant in group 3 signs in, navigates to DO tool,',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_pt(ENV['Alt_Participant_Email'], 'participant1',
                 ENV['Alt_Participant_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_pt(ENV['Alt_Participant_Email'], 'participant1',
                 ENV['Alt_Participant_Password'])
    end

    visit "#{ENV['Base_URL']}/navigator/contexts/DO"
  end

  it 'completes Awareness w/ already entered but not completed awake period' do
    click_on '#1 Awareness'
    click_on 'Next'
    click_on 'Complete'
    fill_in 'activity_type_0', with: 'Get ready for work'
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 7)
    fill_in 'activity_type_1', with: 'Travel to work'
    choose_rating('pleasure_1', 2)
    choose_rating('accomplishment_1', 3)
    fill_in 'activity_type_2', with: 'Work'
    choose_rating('pleasure_2', 8)
    choose_rating('accomplishment_2', 9)
    page.execute_script('window.scrollTo(0,5000)')
    accept_social
    find('#recent_activities')
    click_on 'Next'
    find('#fun_activities')
    click_on 'Next'
    find('#accomplished_activities')
    click_on 'Next'
    find('h1', text: 'Do Landing')
  end

  it 'visits Reviewing from viz at bottom of DO > Landing' do
    expect(page).to have_content 'Recent Past Activities'

    click_on 'Edit'
    expect(page).to have_content 'You said you were going to'
  end
end
