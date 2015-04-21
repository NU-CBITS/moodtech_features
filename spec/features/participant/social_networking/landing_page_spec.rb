# filename: landing_page_spec.rb

describe 'Active participant in a social arm signs in,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
  end

  it 'creates a profile' do
    click_on 'Create a Profile'
    within('.modal-content') do
      page.all('img')[2].click
    end

    within('.list-group-item.ng-scope', text: 'What are your hobbies?') do
      fill_in 'new-answer-description-781294868', with: 'Running'
      click_on 'Save'
    end

    within('.list-group-item.ng-scope', text: 'What is your favorite color?') do
      fill_in 'new-answer-description-932760744', with: 'Blue'
      click_on 'Save'
    end

    within('.list-group-item.ng-scope',
           text: 'Animal, vegetable or mineral?') do
      fill_in 'new-answer-description-10484799', with: 'Mineral'
      click_on 'Save'
    end

    within('.list-group-item.ng-scope', text: 'Group 1 profile question') do
      fill_in 'new-answer-description-933797305', with: 'Group 1'
      click_on 'Save'
    end

    expect(page).to have_css '.fa.fa-pencil'

    visit ENV['Base_URL']
    expect(page).to have_content 'Shared a Profile: Welcome, participant1'
  end

  it 'creates a whats on your mind post' do
    click_on "What's on your mind?"
    fill_in 'new-on-your-mind-description', with: "I'm feeling happy!"
    click_on 'Save'
    expect(page).to have_content "said I'm feeling happy!"
  end

  it 'selects link in TODO list' do
    click_on 'FEEL: Your Recent Moods & Emotions'
    expect(page).to have_content 'Positive and Negative Emotions'
  end

  it 'views another participants profile' do
    within('.profile-border.profile-icon-top',
           text: 'profile question participant') do
      click_on 'profile question participant'
    end

    expect(page).to have_content 'What is your favorite color?'
  end

  it 'likes a whats on your mind post written by another participant' do
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    philly_comment = page.all('.list-group-item.ng-scope',
                              text: "said it's always sunny in Philadelphia")
    within philly_comment[0] do
      find('.btn.btn-link.like.ng-scope').click
      expect(page).to have_css '.fa.fa-thumbs-up.fa-2x'
    end
  end

  it 'comments on a nudge post' do
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    within first('.list-group-item.ng-scope', text: 'nudged participant1') do
      find('.btn.btn-link.comment').click
    end

    expect(page).to have_content 'What do you think?'

    fill_in 'comment-text', with: 'Sweet Dude!'
    click_on 'Save'
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    within first('.list-group-item.ng-scope', text: 'nudged participant1') do
      find('.fa.fa-comments.fa-2x').click
      expect(page).to have_content ': Sweet Dude!'
    end
  end

  it 'checks for due date of a goal post' do
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    within first('.list-group-item.ng-scope', text: 'a Goal: p1 alpha') do
      within('.actions') do
        find('.fa.fa-folder-open.fa-2x.ng-scope').click
      end

      expect(page).to have_content "due #{Date.today.strftime('%b. %e, %Y')}" \
                                   ' at 12:00AM'
    end
  end

  it 'checks for a goal that was due yesterday and is now incomplete' do
    find('h1', text: 'HOME')
    while page.has_no_css?('.list-group-item.ng-scope',
                           text: 'nudged participant1')
      page.execute_script('window.scrollTo(0,100000)')
    end

    expect(page).to have_content 'Did Not Complete Goal: due yesterday'
  end

  it 'does not see an incomplete goal for a goal that was due two days ago' do
    find('h1', text: 'HOME')
    page.execute_script('window.scrollTo(0,100000)')
    expect(page).to_not have_content 'Did Not Complete Goal: due two days ago'
  end
end
