# filename: learn_spec.rb

describe 'Active participant in group 1 signs in, navigates to LEARN,',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_pt(ENV['Participant_Email'], 'participant3',
                 ENV['Participant_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_pt(ENV['Participant_Email'], 'participant3',
                 ENV['Participant_Password'])
    end

    visit "#{ENV['Base_URL']}/navigator/contexts/LEARN"
  end

  it 'sees list opened to this week, collapses list' do
    expect(page).to have_content 'Week 1'

    expect(page).to have_content 'Do - Awareness Introduction'

    first('.panel-title', text: 'Week 1').click
    expect(page).to_not have_content 'Do - Awareness Introduction'
  end

  it 'reads Lesson 1' do
    click_on 'Do - Awareness Introduction'
    expect(page).to have_content 'This is just the beginning...'
    click_on 'Next'
    click_on 'Finish'
    expect(page).to have_content "Read on #{Date.today.strftime('%b %d %Y')}"

    expect(page).to have_content 'Printable'

    visit ENV['Base_URL']
    find_feed_item('Read a Lesson: Do - Awareness Introduction')
    expect(page).to have_content 'Read a Lesson: Do - Awareness Introduction'
  end

  it 'prints a read lesson' do
    click_on 'Printable'
    expect(page).to have_content 'Print'

    expect(page).to have_content 'Return to Lessons'

    click_on 'Return to Lessons'
    expect(page).to have_content 'Week 1'
  end

  it 'only sees lessons listed to the end of study length' do
    eight_wks = Date.today + 49
    nine_wks = Date.today + 56
    expect(page)
      .to have_css('.panel-title.panel-unreleased',
                   text: "Week 8 · #{eight_wks.strftime('%b %d %Y')}")
    expect(page)
      .to_not have_css('.panel-title.panel-unreleased',
                       text: "Week 9 · #{nine_wks.strftime('%b %d %Y')}")
  end
end
