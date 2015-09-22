# filename: coach_groups_spec.rb

describe 'Coach signs in and navigates to Group Dashboard of Group 6',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_user(ENV['Clinician_Email'], 'participant1',
                   ENV['Clinician_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                   ENV['Clinician_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
    click_on 'Arm 1'
    click_on 'Group 6'
    click_on 'Group Dashboard'
  end

  it 'views Group Summary' do
    within('.panel.panel-default', text: 'Group Summary') do
      check_data('tr:nth-child(2)', 'logins  7 10 4 3 5 0 0 0')

      check_data('tr:nth-child(3)', 'thoughts  1 0 1 1 1 0 0 0')

      check_data('tr:nth-child(4)', 'activities past  1 0 1 0 0 0 0 0')

      check_data('tr:nth-child(5)', 'activities future  0 0 0 0 2 0 0 0')

      check_data('tr:nth-child(6)', 'on the mind statements  0 0 0 1 0 0 0 0')

      check_data('tr:nth-child(7)', 'comments  0 0 2 0 1 0 0 0')

      check_data('tr:nth-child(8)', 'goals  1 2 0 0 0 0 0 0')

      check_data('tr:nth-child(9)', 'likes  1 2 1 0 1 0 0 0')
    end
  end

  it 'uses the links within Group Summary' do
    within('.panel.panel-default', text: 'Group Summary') do
      items = ['logins', 'thoughts', 'activities past', 'activities future',
               'on the mind statements', 'comments', 'goals', 'likes']
      items.each do |tool|
        click_on tool
      end
    end
  end

  it 'views Logins by Week' do
    within('.panel.panel-default', text: 'Logins By Week') do
      check_data('tr:nth-child(2)', 'First 4 3 0 2 2 0 0 0')

      check_data('tr:nth-child(3)', 'Second  2 1 1 1 2 0 0 0')

      check_data('tr:nth-child(4)', 'Third  1 0 1 0 1 0 0 0')

      check_data('tr:nth-child(5)', 'Fourth  0 6 1 0 0 0 0 0')

      check_data('tr:nth-child(6)', 'Fifth  0 0 1 0 0 0 0 0')
    end
  end

  it 'views Lesson View Summary' do
    within('.panel.panel-default', text: 'Lesson View Summary') do
      table_row_0 = page.all('tr:nth-child(1)')
      within table_row_0[0] do
        expect(page).to have_content 'Home Introduction 1 of 5 COMPLETE'

        page.execute_script('window.scrollTo(0,5000)')
        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'First'
        end

        click_on 'View Incomplete Participants'
        find('.collapse.in')
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'Second Third Fourth Fifth'
        end
      end

      within first('tr:nth-child(2)') do
        expect(page).to have_content 'Do - Awareness Introduction 2 of 5 ' \
                                     'COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'Second Third'
        end

        click_on 'View Incomplete Participants'
        find('.collapse.in')
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'First Fourth Fifth'
        end
      end

      within first('tr:nth-child(3)') do
        expect(page).to have_content 'Do - Planning Introduction 1 of 5 ' \
                                     'COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'Second'
        end

        click_on 'View Incomplete Participants'
        find('.collapse.in')
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'First Third Fourth Fifth'
        end
      end

      within table_row_0[4] do
        expect(page).to have_content 'Think - Identifying Conclusion 3 of 5 ' \
                                     'COMPLETE'

        page.execute_script('window.scrollTo(0,5000)')
        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'First Second Third'
        end

        click_on 'View Incomplete Participants'
        find('.collapse.in')
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'Fourth Fifth'
        end
      end
    end
  end

  it 'views Thoughts' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'thoughts'
    end

    within('#thoughts-container') do
      find('.sorting', text: 'Week').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 34
        expect(page).to have_content 'First I am no good  Labeling and ' \
                                     'Mislabeling  I did good at work '  \
                                     'today  I am good  ' \
                                     "#{date_1.strftime('%b %d %Y')}"

        expect(page).to have_content '  1 1 1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 20
        expect(page).to have_content 'First This is stupid  Fortune ' \
                                     'Telling  It could be useful  I ' \
                                     'should try it out  ' \
                                     "#{date_2.strftime('%b %d %Y')}"

        expect(page).to have_content '  3 0 0'
      end
    end
  end

  it 'views Activities Past' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'activities past'
    end

    within('#activities-past-container') do
      find('.sorting', text: 'Week').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 33
        date_2 = Date.today - 34
        expect(page).to have_content 'First Running reviewed and complete ' \
                                     "#{date_1.strftime('%b %d %Y')}"

        expect(page).to have_content "6 5 6 8 #{date_2.strftime('%b %d %Y')}"

        expect(page).to have_content '1 0 0'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today - 20
        date_4 = Date.today - 21
        expect(page).to have_content 'Second Jumping reviewed and complete ' \
                                     "#{date_3.strftime('%b %d %Y')}"

        expect(page).to have_content "6 9 9 3 #{date_4.strftime('%b %d %Y')}"

        expect(page).to have_content '3 1 1'
      end
    end
  end

  it 'views Activities Future' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'activities future'
    end

    within('#activities-planned-container') do
      find('.sorting', text: 'Week').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today + 4
        expect(page).to have_content 'Third Go to movie ' \
                                     "#{date_1.strftime('%b %d %Y')}"

        date_2 = Date.today - 1
        expect(page).to have_content '9 7 ' \
                                     "#{date_2.strftime('%b %d %Y')}"

        expect(page).to have_content '5 1 1'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today + 7
        expect(page).to have_content 'Fourth Yelling ' \
                                     "#{date_3.strftime('%b %d %Y')}"

        date_4 = Date.today - 1
        expect(page).to have_content '0 2 ' \
                                     "#{date_4.strftime('%b %d %Y')}"

        expect(page).to have_content '5 0 0'
      end
    end
  end

  it 'views On-My-Mind Statements' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'on the mind statements'
    end

    within('#on-my-mind-container') do
      find('.sorting', text: 'Week').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 14
        expect(page).to have_content "First I'm feeling great!  " \
                                     "#{date_1.strftime('%b %d %Y')}"

        expect(page).to have_content '4 0 0'
      end
    end
  end

  it 'views Comments' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'comments'
    end

    within('#comments-container') do
      find('.sorting', text: 'Created At').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 20
        expect(page).to have_content 'Second Nice job on identifying the ' \
                                     'pattern!  Thought: participant61, ' \
                                     'I am no good ' \
                                     "#{date_1.strftime('%b %d %Y')}"

        expect(page).to have_content '1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 18
        expect(page).to have_content 'First Great activity! Activity: ' \
                                     'participant62, Jumping, ' \
                                     "#{date_2.strftime('%b %d %Y')}"

        expect(page).to have_content '3'
      end

      within('tr:nth-child(3)') do
        date_3 = Date.today - 1
        expect(page).to have_content 'Fifth That sounds like fun! Activity: ' \
                                     'participant63, Go to movie, ' \
                                     "#{date_3.strftime('%b %d %Y')}"

        expect(page).to have_content '5'
      end
    end
  end

  it 'views Goals' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'goals'
    end

    within('#goals-container') do
      find('.sorting', text: 'Created Date').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 30
        date_2 = Date.today - 26
        date_3 = Date.today - 34
        expect(page).to have_content 'First do something  incomplete ' \
                                     "#{date_1.strftime('%b %d %Y')} "

        expect(page).to have_content "#{date_2.strftime('%m/%d/%Y')} "

        expect(page).to have_content "#{date_3.strftime('%b %d %Y')}"

        expect(page).to have_content '1 0 0'
      end

      within('tr:nth-child(2)') do
        date_4 = Date.today + 3
        date_5 = Date.today - 26
        expect(page).to have_content 'Third Get crazy incomplete not deleted ' \
                                     "#{date_4.strftime('%m/%d/%Y')} "

        expect(page).to have_content "#{date_5.strftime('%b %d %Y')}"

        expect(page).to have_content '2 1 0'
      end

      within('tr:nth-child(3)') do
        date_6 = Date.today - 12
        date_7 = Date.today - 14
        date_8 = Date.today - 24
        expect(page).to have_content 'Fifth go to work ' \
                                     "#{date_6.strftime('%b %d %Y')} "

        expect(page).to have_content 'not deleted ' \
                                     "#{date_7.strftime('%m/%d/%Y')} "

        expect(page).to have_content "#{date_8.strftime('%b %d %Y')}"

        expect(page).to have_content '2 1 0'
      end
    end
  end

  it 'views Likes' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'likes'
    end

    within('#likes-container') do
      find('.sorting', text: 'Week').click
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 33
        expect(page).to have_content 'Second  SocialNetworking::SharedItem  ' \
                                     'Thought: I am no good ' \
                                     "#{date_1.strftime('%b %d %Y')}"

        expect(page).to have_content '1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 24
        expect(page).to have_content 'First SocialNetworking::SharedItem  ' \
                                     'Goal: Get crazy ' \
                                     "#{date_2.strftime('%b %d %Y')}"

        expect(page).to have_content '2'
      end

      within('tr:nth-child(3)') do
        date_3 = Date.today - 24
        expect(page).to have_content 'Second  SocialNetworking::SharedItem  ' \
                                     'Goal: go to work ' \
                                     "#{date_3.strftime('%b %d %Y')}"

        expect(page).to have_content '2'
      end

      within('tr:nth-child(4)') do
        date_4 = Date.today - 19
        expect(page).to have_content 'Third  SocialNetworking::SharedItem  ' \
                                     'Activity: Jumping ' \
                                     "#{date_4.strftime('%b %d %Y')}"

        expect(page).to have_content '3'
      end

      within('tr:nth-child(5)') do
        date_5 = Date.today - 1
        expect(page).to have_content 'Fifth  SocialNetworking::SharedItem  ' \
                                     'Activity: Go to movie ' \
                                     "#{date_5.strftime('%b %d %Y')}"

        expect(page).to have_content '5'
      end
    end
  end

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    expect(page).to have_content 'Title: Group 6'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
