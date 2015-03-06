# filename: coach_groups_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Coach signs in and navigates to Group Dashboard of Group 1', type: :feature, sauce: sauce_labs do
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
        expect(page).to have_content 'activities past  0 0 0 0 0 0 0 0'
      end

      within('tr', text: 'activities future') do
        expect(page).to have_content 'activities future  0 0 0 0 0 0 0 0'
      end

      within('tr', text: 'on the mind statements') do
        expect(page).to have_content 'on the mind statements  0 0 0 0 0 0 0 0'
      end

      within('tr', text: 'comments') do
        expect(page).to have_content 'comments  1 0 0 0 0 0 0 0'
      end

      within('tr', text: 'goals') do
        expect(page).to have_content 'goals  0 0 0 0 0 0 0 0'
      end

      within('tr', text: 'likes') do
        expect(page).to have_content 'likes  1 0 0 0 0 0 0 0'
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
        expect(page).to have_content 'Do - Awareness Introduction 2 of 5 COMPLETE'

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
        expect(page).to have_content 'Do - Planning Introduction 1 of 5 COMPLETE'

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
        expect(page).to have_content 'Think - Identifying Conclusion 3 of 5 COMPLETE'

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
        expect(page).to have_content 'First I am no good  harmful '  \
                                     + date_1.strftime('%-d %b') \
                                     + ' 18:00  1 1 1'
      end

      within('tr:nth-child(2)') do
        date_2 = Date.today - 20
        expect(page).to have_content 'First This is stupid  harmful ' \
                                     + date_2.strftime('%-d %b') \
                                     + ' 18:00  3 0 0'
      end
    end
  end

  it 'views Activities Past'

  it 'views Activities Future'

  it 'views Goals'

  it 'views Comments'

  it 'views On-My-Mind Statements'

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
