# filename: think_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# define methods for tests
def compare_thought(thought)
  click_on 'Next'
  expect(page).to have_content 'Thought saved'
  within('.panel-body.adjusted-list-group-item') do
    expect(page).to_not have_content thought
  end

  page.find('.panel-body.adjusted-list-group-item').text
end

# tests
describe 'Active participant signs in and navigates to THINK tool,', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'Add a New Thought'
  end

  it 'completes Identifying module' do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'

    click_on 'Next'
    expect(page).to have_content 'Helpful thoughts are...'

    click_on 'Next'
    expect(page).to have_content 'Harmful thoughts are:'

    click_on 'Next'
    expect(page).to have_content 'Some quick examples...'

    click_on 'Next'
    expect(page).to have_content 'Now, your turn...'

    fill_in 'thought_content', with: 'Testing helpful thought'
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Now list another harmful thought...'

    fill_in 'thought_content', with: 'Testing negative thought'
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Just one more'

    fill_in 'thought_content', with: 'Forced negative thought'
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Good work'

    click_on 'Next'
    expect(page).to have_content 'Add a New Thought'
  end

  it 'completes Patterns module' do
    click_on '#2 Patterns'
    expect(page).to have_content 'Like we said, you are what you think...'

    click_on 'Next'
    expect(page).to have_content "Let's start by"

    thought_value = page.find('.panel-body.adjusted-list-group-item').text

    select 'Personalization', from: 'thought_pattern_id'

    thought_value = compare_thought(thought_value)

    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'

    thought_value = compare_thought(thought_value)

    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'

    thought_value = compare_thought(thought_value)

    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'

    thought_value = compare_thought(thought_value)

    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'

    thought_value = compare_thought(thought_value)

    select 'Personalization', from: 'thought_pattern_id'

    compare_thought(thought_value)

    select 'Personalization', from: 'thought_pattern_id'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    if page.has_text? 'Good work'
      expect(page).to have_content 'We know this can be challenging...'

      click_on 'Next'
      expect(page).to have_content 'Add a New Thought'

    else
      expect(page).to have_content 'Add a New Thought'
    end
  end

  it 'completes Reshape module' do
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'

    click_on 'Next'
    expect(page).to have_content 'You said you had the following unhelpful thoughts:'

    click_on 'Next'
    expect(page).to have_content 'Challenging a thought means'

    click_on 'Next'
    expect(page).to have_content 'You said that you thought...'

    click_on 'Next'
    expect(page).to have_content 'Come up with a challenging'

    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Next'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'You said that you thought...'

    click_on 'Next'
    expect(page).to have_content 'Come up with a challenging'
    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Next'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'You said that you thought...'

    click_on 'Next'
    expect(page).to have_content 'Come up with a challenging'

    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Next'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'

    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Next'
    expect(page).to have_content 'Thought saved'

    if page.has_text? 'Good work'
      click_on 'Next'
    end

    expect(page).to have_content 'Add a New Thought'
  end

  it 'completes Add a New Thought module' do
    click_on 'Add a New Thought'
    expect(page).to have_content 'Add a New Harmful Thought'

    fill_in 'thought_content', with: 'Testing add a new thought'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
    fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Thought saved'

    click_on 'Next'
    expect(page).to have_content 'Add a New Thought'
  end

  it 'cancels Add a New Thought' do
    click_on 'Add a New Thought'
    expect(page).to have_content 'Add a New Thought'

    click_on 'Cancel'
    expect(page).to have_content '#1 Identifying'
  end

  it 'visits Thoughts' do
    click_on 'Thoughts'
    expect(page).to have_content 'Harmful Thoughts'

    expect(page).to have_content 'I am insignificant'
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
    if page.has_text?('You said you had')
      expect(page).to have_content "In case you've forgotten"

    else
      expect(page).to have_content "You don't have"
    end
  end

  it 'uses navbar functionality for all of THINK' do
    visit ENV['Base_URL'] + '/navigator/modules/954850709'
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
    find('.thoughtviz_text.viz-clickable', text: 'Magnification or Catastro...').click
    expect(page).to have_content 'Click a bubble for more info'

    find('.thoughtviz_text.viz-clickable', text: 'Magnification or Catastro...').click
    expect(page).to have_content "Some Thoughts You've Entered"

    expect(page).to have_content 'Testing add a new thought'

    click_on 'Close'
    expect(page).to have_content 'Click a bubble for more info'
  end
end
