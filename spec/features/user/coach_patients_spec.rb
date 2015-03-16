# filename: coach_patients_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Coach signs in,', type: :feature, sauce: sauce_labs do
  context 'navigate to Patient Dashboard of active patient in Group 1' do
    before(:each) do
      visit ENV['Base_URL'] + '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', with: ENV['Clinician_Email']
        fill_in 'user_password', with: ENV['Clinician_Password']
      end

      click_on 'Sign in'
      expect(page).to have_content 'Signed in successfully'

      click_on 'Arms'
      find('h1', text: 'Arms')

      click_on 'Arm 1'
      expect(page).to have_content 'Title: Arm 1'

      click_on 'Group 1'
      expect(page).to have_content 'Title: Group 1'

      click_on 'Patient Dashboard'
      expect(page).to have_css('h1', text: 'Group 1 Patient Dashboard')
    end

    it 'views a list of active participants assigned to the coach' do
      page.find('#patients')[:class].include?('table table-hover')
      expect(page).to have_content 'TFD-1111'
    end

    it 'views a list of inactive participants assigned to the coach' do
      page.find('.btn.btn-default', text: 'Inactive Patients').click
      expect(page).to have_content 'Inactive Status'
      expect(page).to have_content 'Completer'
    end

    it 'selects Discontinue to end active status of participant' do
      within('#patients', text: 'TFD-1111') do
        within('table#patients tr', text: 'TFD-Discontinue') do
          click_on 'Discontinue'
        end
      end

      page.accept_alert 'Are you sure you would like to end this study? ' \
                        'You will not be able to undo this.'
      expect(page).to_not have_content 'TFD-Discontinue'

      click_on 'Inactive Patients'
      expect(page).to have_content 'TFD-Discontinue'
      within('#patients', text: 'TFD-Discontinue') do
        within('table#patients tr', text: 'TFD-Discontinue') do
          today = Date.today
          yesterday = today - 1
          expect(page).to have_content 'Discontinued ' \
                                       + yesterday.strftime('%Y-%m-%d')
        end
      end
    end

    it 'selects Withdraw to end active status of participant' do
      within('#patients', text: 'TFD-1111') do
        within('table#patients tr', text: 'TFD-Withdraw') do
          click_on 'Terminate Access'
        end
      end

      page.accept_alert 'Are you sure you would like to terminate access to ' \
                        'this membership? This option should also be used ' \
                        'before changing membership of the patient to a ' \
                        'different group or to completely revoke access to ' \
                        'this membership. You will not be able to undo this.'
      expect(page).to_not have_content 'TFD-Withdraw'

      click_on 'Inactive Patients'
      expect(page).to have_content 'TFD-Withdraw'
      within('#patients', text: 'TFD-Withdraw') do
        within('table#patients tr', text: 'TFD-Withdraw') do
          today = Date.today
          yesterday = today - 1
          expect(page).to have_content 'Withdrawn ' \
                                       + yesterday.strftime('%Y-%m-%d')
        end
      end
    end

    it 'views General Patient Info' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'General Patient Info') do
        weeks_later = Date.today + 56
        expect(page).to have_content 'Started on: ' \
                                     + Date.today.strftime('%b %-d') \
                                     + "\n8 weeks from the start date is: " \
                                     + weeks_later.strftime('%b %-d') \
                                     + "\nStatus: Active Currently in week 1"
        if page.has_text? 'week: 0'
          expect(page).to have_content 'Lessons read this week: 0'

        else
          expect(page).to have_content 'Lessons read this week: 1'
        end
      end
    end

    it 'views Login Info' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      within('.panel.panel-default', text: 'Login Info') do
        if page.has_text?('Never Logged In')
          expect(page).to have_content "Last Logged In: Never Logged In\n" \
                                       "Logins Today: 0\nLogins in the last " \
                                       "seven days: 0\nTotal Logins: 0"

        else
          expect(page).to have_content 'Last Logged In: ' \
                                       + Time.now.strftime('%-l%P on %b %-d') \
                                       + "\nLogins Today: 61\nLogins in the " \
                                       "last seven days: 61\nTotal Logins: 61"
        end
      end
    end

    it 'views Tool Use table' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      within('.table.table-hover', text: 'Tool Use') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[0] do
          expect(page).to have_content 'Tool Use  Today Last 7 Days Totals'
        end

        within table_row[1] do
          expect(page).to have_content 'Lessons Read    1 1 1'
        end

        within('tr', text: 'Moods') do
          expect(page).to have_content 'Moods   1 1 3'
        end

        within('tr', text: 'Thoughts') do
          expect(page).to have_content 'Thoughts   12 12 12'
        end

        within('tr', text: 'Activities Planned') do
          expect(page).to have_content 'Activities Planned   1 9 9'
        end

        within('tr', text: 'Activities Monitored') do
          expect(page).to have_content 'Activities Monitored   1 9 9'
        end

        within('tr', text: 'Activities Reviewed and Completed') do
          expect(page).to have_content 'Activities Reviewed and Completed 1 2 2'
        end

        within('tr', text: 'Activities Reviewed and Incomplete') do
          expect(page).to have_content 'Activities Reviewed and Incomplete ' \
                                       '0 1 1'
        end
      end
    end

    it 'uses the links within Tool Use table' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      within('.table.table-hover', text: 'Tool Use') do
        click_on 'Lessons Read'
        click_on 'Moods'
        click_on 'Thoughts'
        click_on 'Activities Planned'
        click_on 'Activities Monitored'
        click_on 'Activities Reviewed and Completed'
        click_on 'Activities Reviewed and Incomplete'
      end
    end

    it 'views Social Activity' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      within('.table.table-hover', text: 'Social Activity') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[0] do
          expect(page).to have_content 'Social Activity Today Last 7 Days ' \
                                       'Totals'
        end

        within table_row[1] do
          expect(page).to have_content 'Likes    1 1 1'
        end

        within('tr', text: 'Nudges') do
          expect(page).to have_content 'Nudges   2 3 3'
        end

        within('tr', text: 'Comments') do
          expect(page).to have_content 'Comments   1 1 1'
        end

        within('tr', text: 'Goals') do
          expect(page).to have_content 'Goals   6 6 6'
        end

        within('tr', text: '"On My Mind" Statements') do
          expect(page).to have_content '"On My Mind" Statements   2 2 2'
        end
      end
    end

    it 'uses the links within Social Activity table' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      within('.table.table-hover', text: 'Social Activity') do
        click_on 'Nudges'
        click_on 'Comments'
        click_on 'Goals'
        click_on '"On My Mind" Statements'
      end
    end

    it 'uses the table of contents in the patient report' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.list-group') do
        find('a', text: 'Mood and Emotions Visualizations').click
        page.all('a', text: 'Mood')[1].click
        find('a', text: 'Feelings').click
        find('a', text: 'Logins').click
        find('a', text: 'Lessons').click
        find('a', text: 'Audio Access').click
        find('a', text: 'Activities - Future').click
        find('a', text: 'Activities - Past').click
        page.all('a', text: 'Thoughts')[1].click
        find('a', text: 'Messages').click
        find('a', text: 'Tasks').click
      end

      within('.list-group') do
        find('a', text: 'Activities visualization').click
      end

      expect(page).to have_content 'Daily Averages'

      click_on 'Patient Dashboard'
      expect(page).to have_content 'General Patient Info'

      within('.list-group') do
        find('a', text: 'Thoughts visualization').click
      end

      expect(page).to have_css('#ThoughtVizContainer')

      click_on 'Patient Dashboard'
      expect(page).to have_content 'General Patient Info'
    end

    it 'views Mood/Emotions viz' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('#viz-container.panel.panel-default') do
        expect(page).to have_content 'Mood'

        expect(page).to have_content 'Positive and Negative Emotions'

        today = Date.today
        one_week_ago = today - 6
        one_month_ago = today - 27
        expect(page).to have_content one_week_ago.strftime('%B %e, %Y') \
                                     + ' / ' + today.strftime('%B %e, %Y')

        within('.btn-group') do
          find('.btn.btn-default', text: '28 day').click
        end

        expect(page).to have_content one_month_ago.strftime('%B %e, %Y') \
                                     + ' / ' + today.strftime('%B %e, %Y')

        within('.btn-group') do
          find('.btn.btn-default', text: '7 Day').click
        end

        click_on 'Previous Period'
        one_week_ago_1 = today - 7
        two_weeks_ago = today - 13
        expect(page).to have_content two_weeks_ago.strftime('%B %e, %Y') \
                                     + ' / ' \
                                     + one_week_ago_1.strftime('%B %e, %Y')
      end
    end

    it 'views Mood' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      mood_panel = page.all('.panel.panel-default', text: 'Mood')
      within mood_panel[1] do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content '9'

          four_weeks_ago = Date.today - 28
          expect(page).to have_content four_weeks_ago.strftime('%b. %-d')
        end
      end
    end

    it 'views Feelings' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Feelings') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content 'longing'

          expect(page).to have_content '2'

          expect(page).to have_content Date.today.strftime('%b. %-d')
        end
      end
    end

    it 'views Logins' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      login_panel = page.all('.panel.panel-default', text: 'Logins')
      within login_panel[1] do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if page.has_text?('No data')
            expect(page).to have_content 'No data available in table'

          else
            expect(page).to have_content Date.today.strftime('%d %b')
          end
        end
      end
    end

    it 'views Lessons' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      lesson_panel = page.all('.panel.panel-default', text: 'Lessons')
      within lesson_panel[1] do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if page.has_text?('No data')
            expect(page).to have_content 'No data available in table'

          else
            expect(page).to have_content 'Do - Awareness Introduction'

            expect(page).to have_content Date.today.strftime('%-d %b')

            expect(page).to have_content Date.today.strftime('%b. %-d')

            expect(page).to have_content 'less than a minute'
          end
        end
      end
    end

    it 'views Audio Access' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Audio Access') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if page.has_text?('No data')
            expect(page).to have_content 'No data available in table'

          else
            expect(page).to have_content 'Audio!'

            expect(page).to have_content Date.today.strftime('%-d %b')

            expect(page).to have_content Date.today.strftime('%b. %-d')

            expect(page).to have_content 'Not Completed'
          end
        end
      end
    end

    it 'views Activities viz' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      page.all(:link, 'Activities visualization')[1].click
      expect(page).to have_content 'Today'
      today = Date.today
      expect(page).to have_content 'Daily Averages for ' \
                                   + today.strftime('%b %d, %Y')

      click_on 'Daily Summaries'
      expect(page).to have_content 'Average Accomplishment Discrepancy'

      starttime = Time.now - 3600
      endtime = Time.now
      within('.panel.panel-default',
             text: starttime.strftime('%-l %P') + ' - ' \
             + endtime.strftime('%-l %P:') + ' Loving') do
        click_on starttime.strftime('%-l %P') + ' - ' \
                 + endtime.strftime('%-l %P:') + ' Loving'
        within('.panel-collapse.collapse.in') do
          expect(page).to have_content 'Predicted'

          click_on 'Edit'
          expect(page).to have_css('#activity_actual_accomplishment_intensity')
        end
      end

      click_on 'Previous Day'
      yesterday = today - 1
      expect(page).to have_content 'Daily Averages for ' \
                                   + yesterday.strftime('%b %d, %Y')

      click_on 'Next Day'
      expect(page).to have_content 'Daily Averages for ' \
                                   + today.strftime('%b %d, %Y')

      click_on 'Visualize'
      click_on 'Last 3 Days'
      if page.has_text? 'Notice! No activities were completed during this ' \
                        '3-day period.'
        expect(page).to_not have_content today.strftime('%A, %m/%d')

      else
        expect(page).to have_content today.strftime('%A, %m/%d')
      end

      click_on 'Day'
      expect(page).to have_css('#datepicker')
    end

    it 'views Activities - Future' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Activities - Future') do
        within('tr:nth-child(5)') do
          expect(page).to have_content 'Speech  8 4 Scheduled for ' \
                                       + Date.today.strftime('%d %b')
        end
      end
    end

    it 'views Activities - Past' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Activities - Past') do
        within('tr', text: 'Loving') do
          expect(page).to have_content 'Loving  '
          if page.has_text? 'Planned'
            expect(page).to have_content 'Planned 6 4 Not Rated Not Rated ' \
                                         'Scheduled for ' \
                                         + Date.today.strftime('%d %b')
          else
            expect(page).to have_content 'Reviewed & Completed 6 4 7 5 ' \
                                         'Scheduled for ' \
                                         + Date.today.strftime('%d %b')
          end
        end
      end
    end

    it 'views Thoughts viz' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.list-group') do
        find(:link, 'Thoughts visualization').click
      end

      page.find('#ThoughtVizContainer')
    end

    it 'views Thoughts' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      thought_panel = page.all('.panel.panel-default', text: 'Thoughts')
      within thought_panel[0] do
        within('tr:nth-child(3)') do
          if page.has_text?('I am a magnet')
            expect(page).to have_content 'I am a magnet for birds Labeling ' \
                                         'and Mislabeling  It was nature ' \
                                         'Birds have no idea what they are ' \
                                         'doing ' \
                                         + Date.today.strftime('%b. %-d')

          else
            expect(page).to have_content 'Testing negative thought ' \
                                         'Magnification or Catastrophizing ' \
                                         'Example challenge Example ' \
                                         'act-as-if ' \
                                         + Date.today.strftime('%b. %-d')
          end
        end
      end
    end

    it 'views Messages' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Messages') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if page.has_text? 'I like'
            expect(page).to have_content 'I like this app ' \
                                         + Date.today.strftime('%Y-%m-%d')
          else
            expect(page).to have_content 'Reply: Try out the LEARN tool ' \
                                         + Date.today.strftime('%Y-%m-%d')
          end
        end
      end
    end

    it 'views Tasks' do
      within('#patients', text: 'TFD-1111') do
        click_on 'TFD-1111'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-1111')

      within('.panel.panel-default', text: 'Tasks') do
        within 'tr:nth-child(3)' do
          tomorrow = Date.today + 1
          expect(page).to have_content 'Do - Planning Introduction  ' \
                                       + tomorrow.strftime('%-d %b') \
                                       + ' Incomplete'
        end
      end
    end

    it 'uses breadcrumbs to return to home' do
      click_on 'Group'
      within('.breadcrumb') do
        click_on 'Home'
      end

      expect(page).to have_content 'Arms'
    end
  end

  context 'navigates to Patient Dashboard of active patient in Group 6' do
    before(:each) do
      visit ENV['Base_URL'] + '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', with: ENV['Clinician_Email']
        fill_in 'user_password', with: ENV['Clinician_Password']
      end

      click_on 'Sign in'
      expect(page).to have_content 'Signed in successfully'

      click_on 'Arms'
      find('h1', text: 'Arms')

      click_on 'Arm 1'
      expect(page).to have_content 'Title: Arm 1'

      click_on 'Group 6'
      expect(page).to have_content 'Title: Group 6'

      click_on 'Patient Dashboard'
      expect(page).to have_css('h1', text: 'Group 6 Patient Dashboard')

      within('#patients', text: 'participant61') do
        click_on 'participant61'
      end

      expect(page).to have_css('h1', text: 'Participant participant61')
    end

    it 'views Likes' do
      likes_panel = page.all('.panel.panel-default.cdb_panel', text: 'Likes')
      within likes_panel[0] do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 24
          expect(page).to have_content 'Goal: participant63, Get crazy ' \
                                       + created_date.strftime('%-d %b')

          expect(page).to have_content '2'
        end
      end
    end

    it 'views Goals' do
      within('.panel.panel-default.cdb_panel', text: 'Goals') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          due_date = Date.today - 26
          created_date = Date.today - 34
          expect(page).to have_content 'do something  false true ' \
                                       + due_date.strftime('%-d %b') + ' ' \
                                       + created_date.strftime('%-d %b')

          expect(page).to have_content ' 1 0 0'
        end
      end
    end

    it 'views Comments' do
      comments_panel = page.all('.panel.panel-default.cdb_panel',
                                text: 'Comments')
      within comments_panel[1] do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 20
          expect(page).to have_content 'Great activity! Activity: ' \
                                       'participant62, Jumping, ' \
                                       + created_date.strftime('%-d %b')

          expect(page).to have_content '3'
        end
      end
    end

    it 'views Nudges Initiated' do
      within('.panel.panel-default', text: 'Nudges Initiated') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%-d %b')

          expect(page).to have_content 'participant62'
        end
      end
    end

    it 'views Nudges Received' do
      within('.panel.panel-default', text: 'Nudges Received') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%-d %b')

          expect(page).to have_content 'participant65'
        end
      end
    end

    it 'views On-My-Mind Statements' do
      within('.panel.panel-default.cdb_panel',
             text: 'On-My-Mind Statements') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 14
          expect(page).to have_content "I'm feeling great! " \
                                       + created_date.strftime('%-d %b')

          expect(page).to have_content '4 0 0'
        end
      end
    end
  end
end
