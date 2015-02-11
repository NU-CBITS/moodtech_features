# filename: coach_patients_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Coach, Patients', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Clinician_Email']
      fill_in 'user_password', with: ENV['Clinician_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Patient Dashboard'
    expect(page).to have_content 'Patient Dashboard'
  end

  # tests
  # Testing view patient dashboard
  it '- view patients dashboard' do
    page.find('#patients')[:class].include?('table table-hover')
  end

  # Testing viewing Inactive Patients page
  it '- view inactive patients list' do
    page.find('.btn.btn-default', text: 'Inactive Patients').click
    expect(page).to have_content 'Inactive Status'
  end

  # Testing Discontinue
  it '- selects Discontinue to end active status of participant' do
    within('.table.table-hover') do
      within('tr', text: 'TFD-Discontinue') do
        find('.btn.btn-primary.btn-default', text: 'Discontinue').click
      end
    end

    page.accept_alert 'Are you sure you would like to end this study? You will not be able to undo this.'
    expect(page).to_not have_content 'TFD-Discontinue'

    click_on 'Inactive Patients'
    expect(page).to have_content 'TFD-Discontinue'
    within('.table.table-hover') do
      within('tr', text: 'TFD-Discontinue') do
        today = Date.today
        expect(page).to have_content 'Discontinued ' + today.strftime('%Y-%m-%d')
      end
    end
  end

  # Testing Terminate Access
  it '- selects Withdraw to end active status of participant' do
    within('.table.table-hover') do
      within('tr', text: 'TFD-Withdraw') do
        find('.btn.btn-primary.btn-default', text: 'Terminate Access').click
      end
    end

    page.accept_alert 'Are you sure you would like to terminate access to this membership? ' \
                        'This option should also be used before changing membership of the patient' \
                        ' to a different group or to completely revoke access to this membership. You will not be able to undo this.'
    expect(page).to_not have_content 'TFD-Withdraw'

    click_on 'Inactive Patients'
    expect(page).to have_content 'TFD-Withdraw'
    within('.table.table-hover') do
      within('tr', text: 'TFD-Withdraw') do
        today = Date.today
        expect(page).to have_content 'Withdrawn ' + today.strftime('%Y-%m-%d')
      end
    end
  end

  # Testing specific patient report
  it '- view patient report' do
    within('.table.table-hover') do
      click_on 'TFD-1111'
    end
    expect(page).to have_content 'General Patient Info'
  end

  # Testing viewing Mood viz
  it '- views Mood/Emotions viz' do
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[1]/td[1]/a').click
    within('#viz-container.panel.panel-default') do
      expect(page).to have_content 'Mood'

      expect(page).to have_content 'Positive and Negative Emotions'

      today = Date.today
      one_week_ago = today - 6
      one_month_ago = today - 27
      expect(page).to have_content one_week_ago.strftime('%B %e, %Y') + ' / ' + today.strftime('%B %e, %Y')

      find(:xpath, '//*[@id="viz-container"]/div[2]/div[1]/div/label[2]').click
      expect(page).to have_content one_month_ago.strftime('%B %e, %Y') + ' / ' + today.strftime('%B %e, %Y')

      find(:xpath, '//*[@id="viz-container"]/div[2]/div[1]/div/label[1]').click
      click_on 'Previous Period'
      one_week_ago_1 = today - 7
      two_weeks_ago = today - 13
      expect(page).to have_content two_weeks_ago.strftime('%B %e, %Y') + ' / ' + one_week_ago_1.strftime('%B %e, %Y')
    end
  end

  # Testing viewing activities viz in patient report
  it '- view activities viz' do
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[1]/td[1]/a').click
    expect(page).to have_content 'General Patient Info'

    click_on 'Activities visualization'
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

  # Testing viewing thoughts viz in patient report
  it '- view thoughts viz' do
    find(:xpath, 'html/body/div[1]/div/div/div[2]/div[2]/table/tbody/tr[1]/td[1]/a').click
    expect(page).to have_content 'General Patient Info'

    click_on 'Thoughts visualization'
    page.find('#ThoughtVizContainer')
  end
end
