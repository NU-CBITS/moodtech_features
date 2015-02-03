# filename: think_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Think', type: :feature, sauce: sauce_labs do
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

  # tests
  # Testing the #1-Identifying portion of the THINK tool
  it '- identifying' do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'
    click_on 'Continue'
    expect(page).to have_content 'Helpful thoughts are...'
    click_on 'Continue'
    expect(page).to have_content 'Harmful thoughts are:'
    click_on 'Continue'
    expect(page).to have_content 'Some quick examples...'

    click_on 'Continue'
    expect(page).to have_content 'Now, your turn...'

    fill_in 'thought_content', with: 'Testing helpful thought'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Now list another harmful thought...'

    fill_in 'thought_content', with: 'Testing negative thought'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Just one more'

    fill_in 'thought_content', with: 'Forced negative thought'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Good work'

    click_on 'Continue'
    expect(page).to have_content 'Add a New Thought'
  end

  # Testing the #2-Patterns portion of the THINK tool
  it '- patterns' do
    click_on '#2 Patterns'
    expect(page).to have_content 'Like we said, you are what you think...'
    click_on 'Continue'
    expect(page).to have_content 'All-or-Nothing'
    click_on 'Continue'
    expect(page).to have_content 'Overgeneralization'
    click_on 'Continue'
    expect(page).to have_content 'Mental Filter'
    click_on 'Continue'
    expect(page).to have_content 'Fortune Telling'
    click_on 'Continue'
    expect(page).to have_content 'Magnification or Catastrophizing'
    click_on 'Continue'
    expect(page).to have_content '\"Should\" Statements'
    click_on 'Continue'
    expect(page).to have_content 'Labeling and Mislabeling'
    click_on 'Continue'
    expect(page).to have_content 'Personalization'
    click_on 'Continue'
    expect(page).to have_content 'Helpful Thoughts'
    expect(page).to have_content 'Last time you were here...'
    click_on 'Continue'
    expect(page).to have_content "Let's start by"
    select 'Personalization', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'

    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Testing helpful thought'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Public thought 2'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Private thought 1'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Public thought 1'
    select 'Personalization', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'I am insignificant'
    select 'Personalization', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'ARG!'
    select 'Personalization', from: 'thought_pattern_id'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'

    if page.has_text? 'Good work'
      expect(page).to have_content 'We know this can be challenging...'
      click_on 'Continue'
      expect(page).to have_content 'Add a New Thought'
    else
      expect(page).to have_content 'Add a New Thought'
    end
  end

  # Testing the #3-Reshape portion of the THINK tool
  it '- reshape' do
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'
    click_on 'Continue'
    expect(page).to have_content 'You said you had the following unhelpful thoughts:'
    click_on 'Continue'
    expect(page).to have_content 'Challenging a thought means'
    click_on 'Continue'
    expect(page).to have_content 'You said that you thought...'
    click_on 'Continue'
    expect(page).to have_content 'Come up with a challenging'
    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Continue'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'You said that you thought...'

    click_on 'Continue'
    expect(page).to have_content 'Come up with a challenging'
    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Continue'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'You said that you thought...'

    click_on 'Continue'
    expect(page).to have_content 'Come up with a challenging'
    fill_in 'thought[challenging_thought]', with: 'Example challenge'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Because what you THINK, FEEL, Do'

    click_on 'Continue'
    expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
    fill_in 'thought_act_as_if', with: 'Example act-as-if'
    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Good work'

    click_on 'Continue'
    expect(page).to have_content 'Add a New Thought'
  end

  # Testing the Add a New Thought portion of the THINK tool
  it '- add a new thought' do
    click_on 'Add a New Thought'
    expect(page).to have_content 'Add a New Harmful Thought'
    fill_in 'thought_content', with: 'Testing add a new thought'
    select 'Magnification or Catastrophizing', from: 'thought_pattern_id'
    fill_in 'thought_challenging_thought', with: 'Testing challenge thought'
    fill_in 'thought_act_as_if', with: 'Testing act-as-if action'
    click_on 'Continue'
    page.accept_alert 'Are you sure that you would like to make this activity public?'
    expect(page).to have_content 'Thought saved'

    click_on 'Continue'
    expect(page).to have_content 'Add a New Thought'
  end

  # Testing the Cancel button in Add a New Thought
  it '- add a new thought, cancel' do
    click_on 'Add a New Thought'
    expect(page).to have_content 'Add a New Thought'
    click_on 'Cancel'
    expect(page).to have_content '#1 Identifying'
  end

  # Testing the Thoughts portion of the THINK tool
  it '- check thoughts' do
    click_on 'Thoughts'
    expect(page).to have_content 'Harmful Thoughts'
    expect(page).to have_content 'I am insignificant'
  end

  # Testing the skip functionality in the first slideshows of the first three portions of the THINK tool
  it '- skip functionality' do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'
    click_on 'Skip'
    expect(page).to have_content 'Now, your turn...'

    click_on 'THINK'
    click_on '#2 Patterns'
    expect(page).to have_content 'Like we said, you are what you think... '
    click_on 'Skip'
    expect(page).to have_content 'All-or-Nothing'

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

  # Testing navbar functionality specifically surrounding the THINK tool
  it '- navbar functionality' do
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

  # Testing the THINK tool visualization
  it '- visualization' do
    find('.thoughtviz_text.viz-clickable', text: 'Magnification or Catastro...').click
    expect(page).to have_content 'Click a bubble for more info'
    find('.thoughtviz_text.viz-clickable', text: 'Magnification or Catastro...').click
    expect(page).to have_content "Some Thoughts You've Entered"
    expect(page).to have_content 'Testing add a new thought'

    click_on 'Close'
    expect(page).to have_content 'Click a bubble for more info'
  end
end
