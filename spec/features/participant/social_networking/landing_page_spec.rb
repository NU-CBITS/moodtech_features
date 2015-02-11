# filename: landing_page_spec.rb

require_relative '../../../../spec/spec_helper'
require_relative '../../../../spec/configure_cloud'

describe 'Social Networking landing page', type: :feature, sauce: sauce_labs do
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

  # tests
  it '- create a profile' do
    click_on 'Create a Profile'
    within('.modal-content') do
      expect(page).to have_content 'Start creating'

      find(:xpath, '//*[@id="profile-icon-selection"]/div[2]/div/div[2]/div[1]/div[3]').click
    end

    within('.list-group-item.ng-scope', text: 'What are your hobbies?') do
      fill_in 'new-answer-description-781294868', with: 'Running'
      click_on 'Save'
    end
    within('.list-group-item.ng-scope', text: 'What is your favorite color?') do
      fill_in 'new-answer-description-932760744', with: 'Blue'
      click_on 'Save'
    end
    within('.list-group-item.ng-scope', text: 'Animal, vegetable or mineral?') do
      fill_in 'new-answer-description-10484799', with: 'Mineral'
      click_on 'Save'
    end
    within('.list-group-item.ng-scope', text: 'Group 1 profile question') do
      fill_in 'new-answer-description-933797305', with: 'Group 1'
      click_on 'Save'
    end

    expect(page).to have_css '.fa.fa-pencil'

    visit ENV['Base_URL']
    expect(page).to have_content 'created a Profile: Welcome, participant1'
  end

  it '- create a whats on your mind post' do
    click_on "What's on your mind?"
    fill_in 'new-on-your-mind-description', with: "I'm feeling happy!"
    click_on 'Save'
    expect(page).to have_content "said I'm feeling happy!"
  end

  it '- select link in TODO list' do
    click_on 'FEEL: Your Recent Moods & Emotions'
    expect(page).to have_content 'Mood'

    expect(page).to have_content 'Positive and Negative Emotions'
  end

  it '- view another participants profile' do
    within('.profile-border.profile-icon-top', text: 'profile question participant') do
      click_on 'profile question participant'
    end

    expect(page).to have_content 'What is your favorite color?'
  end

  it '- like a whats on your mind post written by another participant' do
    within('.list-group-item.ng-scope', text: "said it's always sunny in Philadelphia") do
      find('.btn.btn-link.like.ng-scope').click
      expect(page).to have_css '.fa.fa-thumbs-up.fa-2x'
    end
  end

  it '- comment on a nudge post' do
    within first('.list-group-item.ng-scope', text: 'nudged participant1') do
      find('.btn.btn-link.comment').click
    end

    expect(page).to have_content 'What do you think?'

    fill_in 'comment-text', with: 'Sweet Dude!'
    click_on 'Save'
    expect(page).to have_content "said it's always sunny in Philadelphia"

    within first('.list-group-item.ng-scope', text: 'nudged participant1') do
      find('.fa.fa-comments.fa-2x').click
      expect(page).to have_content ': Sweet Dude!'
    end
  end

  it '- check for due date of a goal post' do
    within first('.list-group-item.ng-scope', text: 'a Goal: p1 alpha') do
      within('.actions') do
        find('.fa.fa-folder-open.fa-2x.ng-scope').click
      end
      expect(page).to have_content 'due ' + Date.today.strftime('%b. %e, %Y') + ' at 12:00AM'
    end
  end
end
