# filename: coach_patients_spec.rb

describe 'Patient Dashboard - ', type: :feature, sauce: sauce_labs do
  describe 'Coach signs in, navigates to Patient Dashboard of ' \
           'active patient in Group 1,' do
    before do
      unless ENV['safari']
        sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                     ENV['Clinician_Password'])
      end

      visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
      click_on 'Arm 1'
      click_on 'Group 1'
      click_on 'Patient Dashboard'
    end

    it 'views a list of active participants assigned to the coach' do
      within('#patients') do
        expect(page).to have_content 'TFD-1111'
      end
    end

    it 'views a list of inactive participants assigned to the coach' do
      find('.btn.btn-default', text: 'Inactive Patients').click
      expect(page).to have_content 'Completer'
    end

    it 'selects Withdraw to end active status of participant and is still' \
       'able to see patient specific data' do
      within('table#patients tr', text: 'TFD-Withdraw') do
        unless driver == :firefox
          page.driver
            .execute_script('window.confirm = function() {return true}')
        end

        click_on 'Terminate Access'
      end

      if driver == :firefox
        page.accept_alert 'Are you sure you would like to terminate access to' \
                          ' this membership? This option should also be used ' \
                          'before changing membership of the patient to a ' \
                          'different group or to completely revoke access to ' \
                          'this membership. You will not be able to undo this.'
      end

      expect(page).to_not have_content 'TFD-Withdraw'

      click_on 'Inactive Patients'
      expect(page).to have_content 'TFD-Withdraw'

      within('table#patients tr', text: 'TFD-Withdraw') do
        expect(page)
          .to have_content 'Withdrawn ' \
                           "#{Date.today.prev_day.strftime('%m/%d/%Y')}"
        click_on 'TFD-Withdraw'
      end

      expect(page).to have_css('h1', text: 'Participant TFD-Withdraw')
    end

    it 'views General Patient Info' do
      select_patient('TFD-1111')
      within('.panel.panel-default', text: 'General Patient Info') do
        weeks_later = Date.today + 56
        expect(page).to have_content 'Started on: ' \
                                     "#{Date.today.strftime('%A, %m/%d/%Y')}" \
                                     "\n8 weeks from the start date is: " \
                                     "#{weeks_later.strftime('%A, %m/%d/%Y')}" \
                                     "\nStatus: Active Currently in week 1"

        unless page.has_text? 'week: 0'
          expect(page).to have_content 'Lessons read this week: 1'
        end
      end
    end

    it 'views Tool Use table' do
      select_patient('TFD-1111')
      within('.table.table-hover', text: 'Tool Use') do
        table_row = page.all('tr:nth-child(1)')
        check_data(table_row[0], 'Tool Use  Today Last 7 Days Totals')

        check_data(table_row[1], 'Lessons Read 1 1 1')

        check_data("'tr', text: 'Moods'", '1 1 3')

        check_data("'tr', text: 'Thoughts'", '12 12 12')

        check_data("'tr', text: 'Activities Monitored'", '18 18 18')

        check_data("'tr', text: 'Activities Planned'", '14 16 16')

        check_data("'tr', text: 'Activities Reviewed and Completed'", '1 2 2')

        check_data("'tr', text: 'Activities Reviewed and Incomplete'", '1 1 1')
      end
    end

    it 'uses the links within Tool Use table' do
      select_patient('TFD-1111')
      within('.table.table-hover', text: 'Tool Use') do
        item = ['Lessons Read', 'Moods', 'Thoughts', 'Activities Planned',
                'Activities Monitored', 'Activities Reviewed and Completed',
                'Activities Reviewed and Incomplete']
        item.each do |tool|
          click_on tool
        end
      end
    end

    it 'views Social Activity' do
      select_patient('TFD-1111')
      within('.table.table-hover', text: 'Social Activity') do
        table_row = page.all('tr:nth-child(1)')
        check_data(table_row[0], 'Social Activity Today Last 7 Days Totals')

        check_data(table_row[1], 'Likes 1 1 1')

        check_data("'tr', text: 'Nudges'", 'Nudges 2 3 3')

        check_data("'tr', text: 'Comments'", 'Comments 1 1 1')

        check_data("'tr', text: 'Goals'", 'Goals 5 6 8')

        check_data("'tr', text: 'Statements'", '"On My Mind" Statements 2 2 2')
      end
    end

    it 'uses the links within Social Activity table' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('.table.table-hover', text: 'Social Activity') do
        item = ['Nudges', 'Comments', 'Goals', '"On My Mind" Statements']
        item.each do |data|
          click_on data
        end
      end
    end

    it 'uses the table of contents in the patient report' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('.list-group') do
        item = ['Mood and Emotions Visualizations', 'Feelings', 'Logins',
                'Lessons', 'Audio Access', 'Activities - Future',
                'Activities - Past', 'Messages', 'Tasks']
        item.each do |tool|
          find('a', text: tool).click
        end
        page.all('a', text: 'Mood')[1].click
        page.all('a', text: 'Thoughts')[1].click
      end

      within('.list-group') do
        find('a', text: 'Activities visualization').click
      end

      expect(page).to have_content 'Daily Averages'

      click_on 'Patient Dashboard'
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
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
        expect(page).to have_content "#{one_week_ago.strftime('%b %d %Y')} " \
                                     "- #{Date.today.strftime('%b %d %Y')}"

        page.execute_script('window.scrollTo(0,5000)')
        within('.btn-group') do
          find('.btn.btn-default', text: '28 day').click
        end

        expect(page).to have_content "#{one_month_ago.strftime('%b %d %Y')} " \
                                     "- #{Date.today.strftime('%b %d %Y')}"

        within('.btn-group') do
          find('.btn.btn-default', text: '7 Day').click
        end

        page.execute_script('window.scrollTo(0,5000)')
        click_on 'Previous Period'
        one_week_ago_1 = Date.today - 7
        two_weeks_ago = Date.today - 13
        expect(page).to have_content "#{two_weeks_ago.strftime('%b %d %Y')} " \
                                     "- #{one_week_ago_1.strftime('%b %d %Y')}"
      end
    end

    it 'views Mood' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('#mood-container') do
        find('.sorting_desc', text: 'Date').click
        four_wks_ago = Date.today - 28
        expect(page.all('tr:nth-child(1)')[1])
          .to have_content "9 #{four_wks_ago.strftime('%b %d %Y')}"
      end
    end

    it 'views Feelings' do
      select_patient('TFD-1111')
      within('#feelings-container') do
        expect(page.all('tr:nth-child(1)')[1])
          .to have_content "longing 2 #{Date.today.strftime('%b %d %Y')}"
      end
    end

    it 'views Logins' do
      select_patient('TFD-1111')
      within('#logins-container') do
        unless page.has_text?('No data available in table')
          expect(page.all('tr:nth-child(1)')[1])
            .to have_content Date.today.strftime('%b %d %Y')
        end
      end
    end

    it 'views Lessons' do
      select_patient('TFD-1111')
      within('#lessons-container') do
        unless page.has_text?('No data available in table')
          expect(page.all('tr:nth-child(1)')[1])
            .to have_content 'Do - Awareness Introduction This is just the ' \
                             'beginning... ' \
                             "#{Time.now.strftime('%b %d %Y %I')}"

          expect(page.all('tr:nth-child(1)')[1])
            .to have_content 'less than a minute'
        end
      end
    end

    it 'views Audio Access' do
      select_patient('TFD-1111')
      within('#media-access-container') do
        expect(page.all('tr:nth-child(1)')[1]).to have_content 'Audio! ' \
                                     "#{Date.today.strftime('%m/%d/%Y')}" \
                                     " #{Date.today.strftime('%b %d %Y')}"
        unless page.has_text?('Not Completed')
          expect(page.all('tr:nth-child(1)')[1]).to have_content '2 minutes'
        end
      end
    end

    it 'views Activities viz' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('h3', text: 'Activities visualization') do
        click_on 'Activities visualization'
      end

      expect(page).to have_content 'Daily Averages for ' \
                                   "#{Date.today.strftime('%b %d %Y')}"

      expect(page).to have_content 'Average Accomplishment Discrepancy'

      click_on 'Daily Summaries'
      expect(page).to_not have_content 'Average Accomplishment Discrepancy'

      page.execute_script('window.scrollTo(0,5000)')
      click_on 'Previous Day'
      expect(page)
        .to have_content 'Daily Averages for ' \
                         "#{Date.today.prev_day.strftime('%b %d %Y')}"

      page.execute_script('window.scrollTo(0,5000)')
      endtime = Time.now + (60 * 60)
      within('.panel.panel-default',
             text: "#{Time.now.strftime('%-l %P')} - " \
                   "#{endtime.strftime('%-l %P')}: Parkour") do
        click_on "#{Time.now.strftime('%-l %P')} - " \
                 "#{endtime.strftime('%-l %P')}: Parkour"
        within('.collapse.in') do
          expect(page).to have_content 'Predicted'

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

    it 'views Activities - Future' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('#activities-future-container') do
        find('.sorting', text: 'Activity').click
        within('tr', text: 'Going to school') do
          two_days = Date.today + 2
          expect(page).to have_content 'Going to school  2 6 Scheduled for ' \
                                       "#{two_days.strftime('%b %d %Y')}"
        end
      end
    end

    it 'views Activities - Past' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,5000)')
      within('#activities-past-container') do
        find('.sorting', text: 'Status').click
        find('.sorting_asc', text: 'Status').click
        within('tr', text: 'Parkour') do
          if page.has_text? 'Planned'
            expect(page).
              to have_content '9 4 Not Rated Not Rated  Scheduled for ' \
                              "#{Date.today.prev_day.strftime('%b %d %Y')}"
          else
            expect(page).
              to have_content 'Reviewed & Completed 9 4 7 5 Scheduled for ' \
                              "#{Date.today.prev_day.strftime('%b %d %Y')}"
          end
        end

        if page.all('tr:nth-child(1)')[1]
           .has_text? 'Reviewed and did not complete'
          click_on 'Noncompliance'
          within('.popover.fade.right.in') do
            expect(page).to have_content "Why was this not completed?\nI " \
                                         "didn't have time"
          end
        end
      end
    end

    it 'views Thoughts viz' do
      select_patient('TFD-1111')
      expect(page).to have_content 'General Patient Info'

      page.execute_script('window.scrollTo(0,10000)')
      within('h3', text: 'Thoughts visualization') do
        click_on 'Thoughts visualization'
      end

      find('#ThoughtVizContainer')
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
        within('tr', text: 'Testing negative thought') do
          expect(page).to have_content 'Testing negative thought ' \
                                       'Magnification or Catastrophizing ' \
                                       'Example challenge Example ' \
                                       'act-as-if ' \
                                       "#{Date.today.strftime('%b %d %Y')}"
        end
      end
    end

    it 'views Messages' do
      select_patient('TFD-1111')
      within('#messages-container') do
        within('tr', text: 'I like') do
          expect(page).to have_content 'I like this app ' \
                                       "#{Date.today.strftime('%b %d %Y')}"
        end
      end
    end

    it 'views Tasks' do
      select_patient('TFD-1111')
      within('#tasks-container') do
        within('tr', text: 'Do - Planning Introduction') do
          tomorrow = Date.today + 1
          expect(page).to have_content "#{tomorrow.strftime('%m/%d/%Y')}" \
                             ' Incomplete'
        end
      end
    end

    it 'uses breadcrumbs to return to home' do
      click_on 'Group'
      expect(page).to have_content 'Title: Group 1'

      within('.breadcrumb') do
        click_on 'Home'
      end

      expect(page).to have_content 'Arms'
    end
  end

  describe 'Coach signs in, navigates to Patient Dashboard ' \
           'of active patient in Group 6,' do
    before do
      unless ENV['safari']
        sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                     ENV['Clinician_Password'])
      end

      visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
      click_on 'Arm 1'
      click_on 'Group 6'
      click_on 'Patient Dashboard'
    end

    it 'sees consistent # of Logins' do
      within('#patients') do
        within('table#patients tr', text: 'participant61') do
          date1 = Date.today - 4
          expect(page).to have_content 'participant61 0 6 11 ' \
                                       "#{date1.strftime('%b %d %Y')}"
        end
      end
    end

    it 'views Login Info' do
      select_patient('participant61')
      within('.panel.panel-default', text: 'Login Info') do
        date1 = Date.today - 4
        expect(page).to have_content 'Last Logged In: ' \
                                     "#{date1.strftime('%A, %b %d %Y')}"

        expect(page).to have_content "Logins Today: 0\nLogins during this " \
                                     "treatment week: 0\nTotal Logins: 11"
      end
    end

    it 'views Likes' do
      select_patient('participant61')
      within('#likes-container', text: 'Item Liked') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 24
          expect(page).to have_content 'Goal: participant63, Get crazy ' \
                                       "#{created_date.strftime('%b %d %Y')}"

          expect(page).to have_content '2'
        end
      end
    end

    it 'views Goals' do
      select_patient('participant61')
      within('#goals-container', text: 'Goals') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          due_date = Date.today - 26
          created_date = Date.today - 34
          deleted_date = Date.today - 30
          expect(page).to have_content 'do something  Incomplete ' \
                                       "#{deleted_date.strftime('%b %d %Y')} "

          expect(page).to have_content "#{due_date.strftime('%m/%d/%Y')} "

          expect(page).to have_content "#{created_date.strftime('%b %d %Y')}"

          expect(page).to have_content ' 1 0 0'
        end
      end
    end

    it 'views Comments' do
      select_patient('participant61')
      within('#comments-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 18
          expect(page).to have_content 'Great activity! Activity: ' \
                                       'participant62, Jumping, ' \
                                       "#{created_date.strftime('%b %d %Y')}"

          expect(page).to have_content '3'
        end
      end
    end

    it 'views Nudges Initiated' do
      select_patient('participant61')
      within('.panel.panel-default', text: 'Nudges Initiated') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%b %d %Y')

          expect(page).to have_content 'participant62'
        end
      end
    end

    it 'views Nudges Received' do
      select_patient('participant61')
      within('.panel.panel-default', text: 'Nudges Received') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          expect(page).to have_content Date.today.strftime('%b %d %Y')

          expect(page).to have_content 'participant65'
        end
      end
    end

    it 'views On-My-Mind Statements' do
      select_patient('participant61')
      within('#on-my-mind-container') do
        table_row = page.all('tr:nth-child(1)')
        within table_row[1] do
          created_date = Date.today - 14
          expect(page).to have_content "I'm feeling great! " \
                                       "#{created_date.strftime('%b %d %Y')}"

          expect(page).to have_content '4 0 0'
        end
      end
    end
  end

  describe 'Terminate Access - ' do
    it 'Coach signs in, navigates to Patient Dashboard, ' \
       'selects Terminate Access to end active status of participant,' \
       ' checks to make sure profile is removed' do
      unless ENV['safari']
        sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                     ENV['Clinician_Password'])
      end

      visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
      click_on 'Arm 1'
      click_on 'Group 6'
      click_on 'Patient Dashboard'
      within('#patients', text: 'participant65') do
        within('table#patients tr', text: 'participant65') do
          unless driver == :firefox
            page.driver
              .execute_script('window.confirm = function() {return true}')
          end

          click_on 'Terminate Access'
        end
      end

      if driver == :firefox
        page.accept_alert 'Are you sure you would like to terminate access to' \
                          ' this membership? This option should also be used ' \
                          'before changing membership of the patient to a ' \
                          'different group or to completely revoke access to ' \
                          'this membership. You will not be able to undo this.'
      end

      expect(page).to_not have_content 'participant65'

      click_on 'Inactive Patients'
      expect(page).to have_content 'participant65'

      unless ENV['safari']
        visit "#{ENV['Base_URL']}/participants/sign_in"
        sign_in_pt(ENV['PT61_Email'], 'TFD Moderator',
                   ENV['PT61_Password'])
        expect(page).to have_content 'HOME'

        expect(page).to_not have_content 'Fifth'
      end
    end
  end

  unless ENV['safari']
    describe 'Patient signs in, reads a lesson, signs out,' do
      before do
        sign_in_pt(ENV['PT61_Email'], 'TFD Moderator',
                   ENV['PT61_Password'])
        expect(page).to have_content 'HOME'
        within '.navbar-collapse' do
          click_on 'First'
          click_on 'Sign Out'
        end
      end

      it 'Coach signs in, navigates to Patient Dashboard, views ' \
         "'Last Activity Detected At' and 'Duration of Last Session'" do
        sign_in_user(ENV['Clinician_Email'], 'First', ENV['Clinician_Password'])
        visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
        click_on 'Arm 1'
        click_on 'Group 6'
        click_on 'Patient Dashboard'
        select_patient('participant61')
        expect(page)
          .to have_content 'Last Activity Detected At: ' \
                           "#{Time.now.strftime('%A, %b %d %Y %I:%M %P')}"

        expect(page).to have_content 'Duration of Last Session: ' \
                                     'less than a minute'
      end
    end
  end
end
