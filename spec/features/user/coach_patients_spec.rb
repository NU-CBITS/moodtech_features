# filename: coach_patients_spec.rb

describe 'Coach signs in,', type: :feature, sauce: sauce_labs do
  context 'navigate to Patient Dashboard of active patient in Group 1' do
    before do
      sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])
      click_on 'Arms'
      find('h1', text: 'Arms')
      click_on 'Arm 1'
      click_on 'Group 1'
      click_on 'Patient Dashboard'
    end

    it 'views a list of active participants assigned to the coach' do
      page.find('#patients')[:class].include?('table table-hover')
      expect(page).to have_content 'TFD-1111'
    end

    it 'views a list of inactive participants assigned to the coach' do
      page.find('.btn.btn-default', text: 'Inactive Patients').click
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
          expect(page)
            .to have_content 'Discontinued ' \
                             "#{Date.today.prev_day.strftime('%Y-%m-%d')}"
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
          expect(page)
            .to have_content 'Withdrawn ' \
                             "#{Date.today.prev_day.strftime('%Y-%m-%d')}"
        end
      end
    end

    it 'views General Patient Info' do
      select_patient('TFD-1111')
      within('.panel.panel-default', text: 'General Patient Info') do
        weeks_later = Date.today + 56
        expect(page).to have_content 'Started on: ' \
                                     "#{Date.today.strftime('%b %-d')}" \
                                     "\n8 weeks from the start date is: " \
                                     "#{weeks_later.strftime('%b %-d')}" \
                                     "\nStatus: Active Currently in week 1"

        if page.has_text? 'week: 0'
          expect(page).to have_content 'Lessons read this week: 0'

        else
          expect(page).to have_content 'Lessons read this week: 1'
        end
      end
    end

    it 'views Login Info' do
      select_patient('TFD-1111')
      within('.panel.panel-default', text: 'Login Info') do
        if page.has_text?('Never Logged In')
          expect(page).to have_content "Last Logged In: Never Logged In\n" \
                                       "Logins Today: 0\nLogins in the last " \
                                       "seven days: 0\nTotal Logins: 0"

        else
          expect(page)
            .to have_content 'Last Logged In: ' \
                             "#{Time.now.strftime('%-l%P on %b %-d')}" \
                             "\nLogins Today: 61\nLogins in the " \
                             "last seven days: 61\nTotal Logins: 61"
        end
      end
    end

    it 'views Tool Use table' do
      select_patient('TFD-1111')
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
      select_patient('TFD-1111')
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
      select_patient('TFD-1111')
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
      select_patient('TFD-1111')
      within('.table.table-hover', text: 'Social Activity') do
        click_on 'Nudges'
        click_on 'Comments'
        click_on 'Goals'
        click_on '"On My Mind" Statements'
      end
    end

    it 'uses the table of contents in the patient report' do
      select_patient('TFD-1111')
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
      select_patient('TFD-1111')
      within('#viz-container') do
        expect(page).to have_content 'Mood'

        expect(page).to have_content 'Positive and Negative Emotions'

        one_week_ago = Date.today - 6
        one_month_ago = Date.today - 27
        expect(page).to have_content "#{one_week_ago.strftime('%B %e, %Y')} " \
                                     "/ #{Date.today.strftime('%B %e, %Y')}"

        within('.btn-group') do
          find('.btn.btn-default', text: '28 day').click
        end

        expect(page).to have_content "#{one_month_ago.strftime('%B %e, %Y')} " \
                                     "/ #{Date.today.strftime('%B %e, %Y')}"

        within('.btn-group') do
          find('.btn.btn-default', text: '7 Day').click
        end

        click_on 'Previous Period'
        one_week_ago_1 = today - 7
        two_weeks_ago = today - 13
        expect(page).to have_content "#{two_weeks_ago.strftime('%B %e, %Y')} " \
                                     "/ #{one_week_ago_1.strftime('%B %e, %Y')}"
      end
    end

    it 'views Mood' do
      select_patient('TFD-1111')
      within('#mood-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          four_weeks_ago = Date.today - 28
          expect(page).to have_content "9 #{four_weeks_ago.strftime('%b. %-d')}"
        end
      end
    end

    it 'views Feelings' do
      select_patient('TFD-1111')
      within('#feelings-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content 'longing 2 ' \
                                       "#{Date.today.strftime('%b. %-d')}"
        end
      end
    end

    it 'views Logins' do
      select_patient('TFD-1111')
      within('#logins-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          unless page.has_text?('No data available in table')
            expect(page).to have_content Date.today.strftime('%d %b')
          end
        end
      end
    end

    it 'views Lessons' do
      select_patient('TFD-1111')
      within('#lessons-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          unless page.has_text?('No data available in table')
            expect(page).to have_content 'Do - Awareness Introduction' \
                                         " #{Date.today.strftime('%d %b')}" \
                                         " #{Date.today.strftime('%b. %-d')}"

            expect(page).to have_content 'less than a minute'
          end
        end
      end
    end

    it 'views Audio Access' do
      select_patient('TFD-1111')
      within('#media-access-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content 'Audio! ' \
                                       "#{Date.today.strftime('%d %b')}" \
                                       " #{Date.today.strftime('%b. %-d')}"
          if page.has_text?('Not Completed')
            expect(page).to have_content 'Not Completed'

          else
            expect(page).to have_content '2 minutes'
          end
        end
      end
    end

    it 'views Activities viz' do
      select_patient('TFD-1111')
      within('h3', text: 'Activities visualization') do
        click_on 'Activities visualization'
      end

      expect(page).to have_content 'Daily Averages for ' \
                                   "#{Date.today.strftime('%b %d, %Y')}"

      click_on 'Daily Summaries'
      expect(page).to have_content 'Average Accomplishment Discrepancy'

      starttime = Time.now - 3600
      within('.panel.panel-default',
             text: "#{starttime.strftime('%-l %P')} - " \
                   "#{Time.now.strftime('%-l %P:')} Loving") do
        click_on "#{starttime.strftime('%-l %P')} - " \
                 "#{Time.now.strftime('%-l %P:')} Loving"
        within('.panel-collapse.collapse.in') do
          expect(page).to have_content 'Predicted'

          click_on 'Edit'
          expect(page).to have_css('#activity_actual_accomplishment_intensity')
        end
      end

      click_on 'Previous Day'
      expect(page)
        .to have_content 'Daily Averages for ' \
                         "#{Date.today.prev_day.strftime('%b %d, %Y')}"

      click_on 'Next Day'
      expect(page).to have_content 'Daily Averages for ' \
                                   "#{Date.today.strftime('%b %d, %Y')}"

      click_on 'Visualize'
      click_on 'Last 3 Days'
      if page.has_text? 'Notice! No activities were completed during this ' \
                        '3-day period.'
        expect(page).to_not have_content Date.today.strftime('%A, %m/%d')

      else
        expect(page).to have_content Date.today.strftime('%A, %m/%d')
      end

      click_on 'Day'
      expect(page).to have_css('#datepicker')
    end

    it 'views Activities - Future' do
      select_patient('TFD-1111')
      within('#activities-future-container') do
        within('tr:nth-child(5)') do
          expect(page).to have_content 'Speech  8 4 Scheduled for ' \
                                       "#{Date.today.strftime('%d %b')}"
        end
      end
    end

    it 'views Activities - Past' do
      select_patient('TFD-1111')
      within('#activities-past-container') do
        find('.sorting', text: 'Status').double_click
        within('tr', text: 'Loving') do
          if page.has_text? 'Planned'
            expect(page).to have_content '6 4 Not Rated Not Rated ' \
                                         'Scheduled for ' \
                                         "#{Date.today.strftime('%d %b')}"
          else
            expect(page).to have_content 'Reviewed & Completed 6 4 7 5 ' \
                                         'Scheduled for ' \
                                         "#{Date.today.strftime('%d %b')}"
          end
        end

        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if table_row[1].has_text? 'New planned activity'
            click_on 'Noncompliance'
            within('.popover.fade.right.in') do
              expect(page).to have_content "Why was this not completed?\nI " \
                                           "didn't have time"
            end
          end
        end
      end
    end

    it 'views Thoughts viz' do
      select_patient('TFD-1111')
      within('h3', text: 'Thoughts visualization') do
        click_on 'Thoughts visualization'
      end

      page.find('#ThoughtVizContainer')
      if page.has_text? 'Click a bubble for more info'
        find('.thoughtviz_text.viz-clickable',
             text: 'Magnification or Catastro...').click
        expect(page).to have_content 'Testing add a new thought'

        click_on 'Close'
        expect(page).to have_content 'Click a bubble for more info'
      end
    end

    it 'views Thoughts' do
      select_patient('TFD-1111')
      within('#thoughts-container') do
        within('tr:nth-child(3)') do
          if page.has_text?('I am a magnet')
            expect(page).to have_content 'I am a magnet for birds Labeling ' \
                                         'and Mislabeling  It was nature ' \
                                         'Birds have no idea what they are ' \
                                         'doing ' \
                                         "#{Date.today.strftime('%b. %-d')}"

          else
            expect(page).to have_content 'Testing negative thought ' \
                                         'Magnification or Catastrophizing ' \
                                         'Example challenge Example ' \
                                         'act-as-if ' \
                                         "#{Date.today.strftime('%b. %-d')}"
          end
        end
      end
    end

    it 'views Messages' do
      select_patient('TFD-1111')
      within('#messages-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          if page.has_text? 'I like'
            expect(page).to have_content 'I like this app ' \
                                         "#{Date.today.strftime('%Y-%m-%d')}"
          else
            expect(page).to have_content 'Reply: Try out the LEARN tool ' \
                                         "#{Date.today.strftime('%Y-%m-%d')}"
          end
        end
      end
    end

    it 'views Tasks' do
      select_patient('TFD-1111')
      within('#tasks-container') do
        within('tr', text: 'Do - Planning Introduction') do
          expect(page)
            .to have_content "#{Date.today.next_day.strftime('%d %b')}" \
                             ' Incomplete'
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
    before do
      sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])
      click_on 'Arms'
      find('h1', text: 'Arms')
      click_on 'Arm 1'
      click_on 'Group 6'
      click_on 'Patient Dashboard'
      select_patient('participant61')
    end

    it 'views Likes' do
      within('#goals-container', text: 'Item Liked') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 24
          expect(page).to have_content 'Goal: participant63, Get crazy ' \
                                       "#{created_date.strftime('%d %b')}"

          expect(page).to have_content '2'
        end
      end
    end

    it 'views Goals' do
      within('#goals-container', text: 'Goals') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          due_date = Date.today - 26
          created_date = Date.today - 34
          deleted_date = Date.today - 30
          expect(page).to have_content 'do something  Incomplete ' \
                                       "#{deleted_date.strftime('%d %b')} "

          expect(page).to have_content "#{due_date.strftime('%d %b')} "

          expect(page).to have_content "#{created_date.strftime('%d %b')}"

          expect(page).to have_content ' 1 0 0'
        end
      end
    end

    it 'views Comments' do
      within('#comments-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 18
          expect(page).to have_content 'Great activity! Activity: ' \
                                       'participant62, Jumping, ' \
                                       "#{created_date.strftime('%d %b')}"

          expect(page).to have_content '3'
        end
      end
    end

    it 'views Nudges Initiated' do
      within('.panel.panel-default', text: 'Nudges Initiated') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%d %b')

          expect(page).to have_content 'participant62'
        end
      end
    end

    it 'views Nudges Received' do
      within('.panel.panel-default', text: 'Nudges Received') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%d %b')

          expect(page).to have_content 'participant65'
        end
      end
    end

    it 'views On-My-Mind Statements' do
      within('#on-my-mind-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 14
          expect(page).to have_content "I'm feeling great! " \
                                       "#{created_date.strftime('%d %b')}"

          expect(page).to have_content '4 0 0'
        end
      end
    end
  end
end
