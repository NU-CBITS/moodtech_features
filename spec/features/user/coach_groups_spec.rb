# filename: coach_groups_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Coach signs in and navigates to Group Dashboard of Group 1',
         type: :feature, sauce: sauce_labs do
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

    click_on 'Group Dashboard'
    expect(page).to have_css('h1', text: 'Group Group 6')
  end

  it 'views Group Summary' do
    within('.panel.panel-default', text: 'Group Summary') do
      within('tr', text: 'logins') do
        expect(page).to have_content 'logins  7 10 4 3 5 0 0 0'
      end

      within('tr', text: 'thoughts') do
        expect(page).to have_content 'thoughts  1 0 1 1 1 0 0 0'
      end

      within('tr', text: 'activities past') do
        expect(page).to have_content 'activities past  1 0 1 0 0 0 0 0'
      end

      within('tr', text: 'activities future') do
        expect(page).to have_content 'activities future  0 0 0 0 2 0 0 0'
      end

      within('tr', text: 'on the mind statements') do
        expect(page).to have_content 'on the mind statements  0 0 0 1 0 0 0 0'
      end

      within('tr', text: 'comments') do
        expect(page).to have_content 'comments  0 0 2 0 1 0 0 0'
      end

      within('tr', text: 'goals') do
        expect(page).to have_content 'goals  1 2 0 0 0 0 0 0'
      end

      within('tr', text: 'likes') do
        expect(page).to have_content 'likes  1 2 1 0 1 0 0 0'
      end
    end
  end

  it 'uses the links within Group Summary' do
    within('.panel.panel-default', text: 'Group Summary') do
      click_on 'logins'
      click_on 'thoughts'
      click_on 'activities past'
      click_on 'activities future'
      click_on 'on the mind statements'
      click_on 'comments'
      click_on 'goals'
      click_on 'likes'
    end
  end

  it 'views Logins by Week' do
    within('.panel.panel-default', text: 'Logins By Week') do
      within('tr:nth-child(2)') do
        expect(page).to have_content 'First 4 3 0 2 2 0 0 0'
      end

      within('tr:nth-child(3)') do
        expect(page).to have_content 'Second  2 1 1 1 2 0 0 0'
      end

      within('tr:nth-child(4)') do
        expect(page).to have_content 'Third  1 0 1 0 1 0 0 0'
      end

      within('tr:nth-child(5)') do
        expect(page).to have_content 'Fourth  0 6 1 0 0 0 0 0'
      end

      within('tr:nth-child(6)') do
        expect(page).to have_content 'Fifth  0 0 1 0 0 0 0 0'
      end
    end
  end

  it 'views Lesson View Summary' do
    within('.panel.panel-default', text: 'Lesson View Summary') do
      table_row_0 = page.all('tr:nth-child(1)')
      table_row_1 = page.all('tr:nth-child(2)')
      table_row_2 = page.all('tr:nth-child(3)')
      within table_row_0[0] do
        expect(page).to have_content 'Home Introduction 1 of 5 COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'First'
        end

        click_on 'View Incomplete Participants'
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'Second Third Fourth Fifth'
        end
      end

      within table_row_1[0] do
        expect(page).to have_content 'Do - Awareness Introduction 2 of 5 ' \
                                     'COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'Second Third'
        end

        click_on 'View Incomplete Participants'
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'First Fourth Fifth'
        end
      end

      within table_row_2[0] do
        expect(page).to have_content 'Do - Planning Introduction 1 of 5 ' \
                                     'COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'Second'
        end

        click_on 'View Incomplete Participants'
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'First Third Fourth Fifth'
        end
      end

      within table_row_0[4] do
        expect(page).to have_content 'Think - Identifying Conclusion 3 of 5 ' \
                                     'COMPLETE'

        click_on 'View Complete Participants'
        within('.well') do
          expect(page).to have_content 'First Second Third'
        end

        click_on 'View Incomplete Participants'
        well = page.all('.well')
        within well[1] do
          expect(page).to have_content 'Fourth Fifth'
        end
      end
    end
  end

  it 'views Thoughts' do
    within('.panel.panel-default', text: 'Thoughts') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 34
        expect(page).to have_content 'First I am no good  Labeling and ' \
                                     'Mislabeling  I did good at work '  \
                                     'today  I am good  ' \
                                     + date_1.strftime('%d %b')

        expect(page).to have_content '  1 1 1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 20
        expect(page).to have_content 'First This is stupid  Fortune ' \
                                     'Telling  It could be useful  I ' \
                                     'should try it out  ' \
                                     + date_2.strftime('%d %b')

        expect(page).to have_content '  3 0 0'
      end
    end
  end

  it 'views Activities Past' do
    within('.panel.panel-default', text: 'Activities Past') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 33
        date_2 = Date.today - 34
        expect(page).to have_content 'First Running reviewed and complete ' \
                                     + date_1.strftime('%d %b')

        expect(page).to have_content '6 5 6 8 ' + date_2.strftime('%d %b')

        expect(page).to have_content '1 0 0'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today - 20
        date_4 = Date.today - 21
        expect(page).to have_content 'Second Jumping reviewed and complete ' \
                                     + date_3.strftime('%d %b')

        expect(page).to have_content '6 9 9 3 ' + date_4.strftime('%d %b')

        expect(page).to have_content '3 1 1'
      end
    end
  end

  it 'views Activities Future' do
    within('.panel.panel-default', text: 'Activities Future') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today + 4
        date_2 = Date.today - 1
        expect(page).to have_content 'Third Go to movie ' \
                                     + date_1.strftime('%d %b')

        expect(page).to have_content '9 7 ' + date_2.strftime('%d %b')

        expect(page).to have_content '5 1 1'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today + 7
        date_4 = Date.today - 1
        expect(page).to have_content 'Fourth Yelling ' \
                                     + date_3.strftime('%d %b')

        expect(page).to have_content '0 2 ' + date_4.strftime('%d %b')

        expect(page).to have_content '5 0 0'
      end
    end
  end

  it 'views Goals' do
    within('.panel.panel-default', text: 'Goals') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 26
        date_2 = Date.today - 34
        expect(page).to have_content 'First do something  false true  ' \
                                     + date_1.strftime('%-d %b') + ' ' \
                                     + date_2.strftime('%d %b')

        expect(page).to have_content '1 0 0'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today + 3
        date_4 = Date.today - 26
        expect(page).to have_content 'Third Get crazy false false ' \
                                     + date_3.strftime('%-d %b') + ' ' \
                                     + date_4.strftime('%d %b')

        expect(page).to have_content '2 1 0'
      end

      within('tr:nth-child(3)') do
        date_5 = Date.today - 14
        date_6 = Date.today - 24
        expect(page).to have_content 'Fifth go to work true false ' \
                                     + date_5.strftime('%-d %b') + ' ' \
                                     + date_6.strftime('%d %b')

        expect(page).to have_content '2 1 0'
      end
    end
  end

  it 'views Comments' do
    panel_comments = page.all('.panel.panel-default', text: 'Comments')
    within panel_comments[4] do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 20
        expect(page).to have_content 'Second Nice job on identifying the ' \
                                     'pattern!  Thought: participant61, ' \
                                     'I am no good ' + date_1.strftime('%d %b')

        expect(page).to have_content '1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 18
        expect(page).to have_content 'First Great activity! Activity: ' \
                                     'participant62, Jumping, ' \
                                     + date_2.strftime('%d %b')

        expect(page).to have_content '3'
      end

      within('tr:nth-child(3)') do
        date_3 = Date.today - 1
        expect(page).to have_content 'Fifth That sounds like fun! Activity: ' \
                                     'participant63, Go to movie, ' \
                                     + date_3.strftime('%d %b')

        expect(page).to have_content '5'
      end
    end
  end

  it 'views On-My-Mind Statements' do
    within('.panel.panel-default', text: 'On-My-Mind Statements') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 14
        expect(page).to have_content "First I'm feeling great!  " \
                                     + date_1.strftime('%d %b')

        expect(page).to have_content '4 0 0'
      end
    end
  end

  it 'views Goals' do
    within('.panel.panel-default.cdb_panel', text: 'Goals') do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 26
        date_2 = Date.today - 34
        expect(page).to have_content 'First do something  false true ' \
                                     + date_1.strftime('%-d %b') + ' ' \
                                     + date_2.strftime('%-d %b')

        expect(page).to have_content '1 0 0'
      end

      within('tr:nth-child(2)') do
        date_3 = Date.today + 3
        date_4 = Date.today - 26
        expect(page).to have_content 'Third Get crazy  false false ' \
                                     + date_3.strftime('%-d %b') + ' ' \
                                     + date_4.strftime('%-d %b')

        expect(page).to have_content '2 1 0'
      end

      within('tr:nth-child(3)') do
        date_5 = Date.today - 14
        date_6 = Date.today - 24
        expect(page).to have_content 'Fifth go to work  true  false ' \
                                     + date_5.strftime('%-d %b') + ' ' \
                                     + date_6.strftime('%-d %b')

        expect(page).to have_content '2 1 0'
      end
    end
  end

  it 'views Likes' do
    likes_panel = page.all('.panel.panel-default.cdb_panel', text: 'Likes')
    within likes_panel[5] do
      table_row = page.all('tr:nth-child(1)')
      within table_row[1] do
        date_1 = Date.today - 33
        expect(page).to have_content 'Second  SocialNetworking::SharedItem  ' \
                                     'Thought: I am no good ' \
                                     + date_1.strftime('%-d %b')

        expect(page).to have_content '1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 24
        expect(page).to have_content 'First SocialNetworking::SharedItem  ' \
                                     'Goal: Get crazy ' \
                                     + date_2.strftime('%-d %b')

        expect(page).to have_content '2'
      end

      within('tr:nth-child(3)') do
        date_3 = Date.today - 24
        expect(page).to have_content 'Second  SocialNetworking::SharedItem  ' \
                                     'Goal: go to work ' \
                                     + date_3.strftime('%-d %b')

        expect(page).to have_content '2'
      end

      within('tr:nth-child(4)') do
        date_4 = Date.today - 19
        expect(page).to have_content 'Third  SocialNetworking::SharedItem  ' \
                                     'Activity: Jumping ' \
                                     + date_4.strftime('%-d %b')

        expect(page).to have_content '3'
      end

      within('tr:nth-child(5)') do
        date_5 = Date.today - 1
        expect(page).to have_content 'Fifth  SocialNetworking::SharedItem  ' \
                                     'Activity: Go to movie ' \
                                     + date_5.strftime('%-d %b')

        expect(page).to have_content '5'
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
