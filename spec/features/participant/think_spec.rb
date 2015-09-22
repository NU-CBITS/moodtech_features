# filename: think_spec.rb

describe 'Active participant signs in, navigates to THINK tool,',
         type: :feature, sauce: sauce_labs do
  if ENV['safari']
    before(:all) do
      sign_in_pt(ENV['Participant_Email'], 'nonsocialpt',
                 ENV['Participant_Password'])
    end
  end

  before do
    unless ENV['safari']
      sign_in_pt(ENV['Participant_Email'], 'nonsocialpt',
                 ENV['Participant_Password'])
    end

    visit "#{ENV['Base_URL']}/navigator/contexts/THINK"
    expect(page).to have_content 'Add a New Thought'
  end

  it 'completes Identifying module' do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Next'
    expect(page).to have_content 'Helpful thoughts are...'

    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Next'
    expect(page).to have_content 'Harmful thoughts are:'

    click_on 'Next'
    expect(page).to have_content 'Some quick examples...'

    click_on 'Next'
    fill_in 'thought_content', with: 'Testing helpful thought'
    accept_social
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Now list another harmful thought...'

    fill_in 'thought_content', with: 'Testing negative thought'
    accept_social
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Just one more'

    fill_in 'thought_content', with: 'Forced negative thought'
    accept_social
    expect(page).to have_content 'Good work'

    click_on 'Next'
    expect(page).to have_content 'Add a New Thought'

    visit ENV['Base_URL']
    find_feed_item('Identified a Thought: Testing helpful thought')
    within('.list-group-item.ng-scope',
           text: 'Identified a Thought: Testing helpful thought') do
      page.execute_script('window.scrollTo(0,5000)')
      click_on 'More'

      expect(page).to have_content 'this thought is: Testing helpful thought'
    end
  end

  it 'completes Patterns module' do
    click_on '#2 Patterns'
    click_on 'Next'
    expect(page).to have_content "Let's start by"

    thought_value = find('.panel-body.adjusted-list-group-item').text
    select 'Personalization', from: 'thought_pattern_id'
    4.times do
      thought_value = compare_thought(thought_value)
      select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    end
    thought_value = compare_thought(thought_value)
    select 'Personalization', from: 'thought_pattern_id'
    compare_thought(thought_value)
    select 'Personalization', from: 'thought_pattern_id'
    accept_social
    expect(page).to have_content 'Thought saved'

    visit ENV['Base_URL']
    find_feed_item('Assigned a pattern to a Thought: Testing helpful thought')
    test_thought = page.all('.list-group-item.ng-scope', text: 'Assigned a ' \
                            'pattern to a Thought: Testing helpful thought')[0]
    within test_thought do
      click_on 'More'

      expect(page).to have_content 'this thought is: Testing helpful thought' \
                                   "\nthought pattern: Magnification or " \
                                   'Catastrophizing'
    end
  end

  it 'completes Reshape module' do
    click_on '#3 Reshape'
    click_on 'Next'
    expect(page).to have_content 'You said you had the following unhelpful ' \
                                 'thoughts:'

    click_on 'Next'
    expect(page).to have_content 'Challenging a thought means'

    page.execute_script('window.scrollTo(0,10000)')
    click_on 'Next'
    3.times do
      reshape('Example challenge', 'Example act-as-if')
    end
    visit ENV['Base_URL']
    find_feed_item('Reshaped a Thought: Testing helpful thought')
    within('.list-group-item.ng-scope',
           text: 'Reshaped a Thought: Testing helpful thought') do
      click_on 'More'

      expect(page).to have_content 'this thought is: Testing helpful thought' \
                                   "\nthought pattern: Magnification or " \
                                   "Catastrophizing\nchallenging thought: " \
                                   "Example challenge\nas if action: Example" \
                                   ' act-as-if'
    end
  end

  it 'completes Add a New Thought module' do
    click_on 'Add a New Thought'
    fill_in 'thought_content', with: 'Testing add a new thought'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
    fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
    page.execute_script('window.scrollTo(0,5000)')
    accept_social
    expect(page).to have_content 'Thought saved'

    page.execute_script('window.scrollTo(0,5000)')
    find('.btn.btn-primary.pull-right', text: 'Next').click
    expect(page).to have_content 'Add a New Thought'

    visit ENV['Base_URL']
    find_feed_item('Reshaped a Thought: Testing add a new thought')
    within('.list-group-item.ng-scope',
           text: 'Reshaped a Thought: Testing add a new thought') do
      click_on 'More'

      expect(page).to have_content 'this thought is: Testing add a new' \
                                   " thought\nthought pattern: " \
                                   'Magnification or Catastrophizing' \
                                   "\nchallenging thought: Testing challenge " \
                                   "thought\nas if action: Testing act-as-if " \
                                   ' action'
    end
  end

  it 'cancels Add a New Thought' do
    click_on 'Add a New Thought'
    click_on 'Cancel'
    expect(page).to have_content '#1 Identifying'
  end

  it 'visits Thoughts and sort by column Pattern' do
    click_on 'Thoughts'
    expect(page).to have_content 'I am insignificant'

    find('.sorting', text: 'Pattern').click
    expect(page.all('tr:nth-child(1)')[1])
      .to have_content 'Labeling and Mislabeling'
  end

  it 'uses the skip functionality in all the slideshows in THINK' do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'

    click_on 'Skip'
    expect(page).to have_content 'Now, your turn...'

    click_on 'THINK'
    click_on '#2 Patterns'
    expect(page).to have_content 'Like we said, you are what you think... '

    click_on 'Skip'
    expect(page).to have_content "Let's start by"

    click_on 'THINK'
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'

    click_on 'Skip'
    unless page.has_text?("You don't have")
      expect(page).to have_content "In case you've forgotten"
    end
  end

  it 'uses navbar functionality for all of THINK' do
    visit "#{ENV['Base_URL']}/navigator/modules/954850709"
    click_on 'THINK'
    click_on '#2 Patterns'
    expect(page).to have_content 'Like we said, you are what you think...'

    click_on 'THINK'
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'

    click_on 'THINK'
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'

    click_on 'THINK'
    click_on 'Add a New Thought'
    expect(page).to have_content 'Add a New Harmful Thought'

    click_on 'THINK'
    click_on 'Thoughts'
    expect(page).to have_content 'Harmful Thoughts'
  end

  it 'uses the visualization' do
    find('.thoughtviz_text.viz-clickable',
         text: 'Magnification or Catastro...').click
    expect(page).to have_content 'Thought Distortions'

    find('.thoughtviz_text.viz-clickable',
         text: 'Magnification or Catastro...').click
    expect(page).to have_content 'Testing add a new thought'

    click_on 'Close'
    expect(page).to have_content 'Click a bubble for more info'

    sign_out('participant1')
  end
end
