#filename: think_spec.rb

#this file is to test the functionality of the THINK tool

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Think", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Think", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/THINK'
    expect(page).to have_content 'Add a New Thought'
  end

#tests

  #Testing the #1-Identifying portion of the THINK tool
  it "- identifying" do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'
    click_on 'Continue'
    expect(page).to have_content 'Types of thoughts'
    click_on 'Continue'
    expect(page).to have_content 'Helpful thoughts are...'
    click_on 'Continue'
    expect(page).to have_content 'Harmful thoughts are...'
    click_on 'Continue'
    expect(page).to have_content 'Some quick examples...'

    click_on 'Continue'
    expect(page).to have_content 'Now, your turn...'
    fill_in 'thought_content', :with => 'Testing helpful thought'

    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Now list another harmful thought...'
    fill_in 'thought_content', :with => 'Testing negative thought'


    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    expect(page).to have_content 'Just one more'
    fill_in 'thought_content', :with => 'Forced negative thought'
    click_on 'Continue'
    expect(page).to have_content 'Good work'
  end

  #Testing the #2-Patterns portion of the THINK tool
  it "- patterns" do
    click_on '#2 Patterns'
    expect(page).to have_content 'Thinking Patterns'
    click_on 'Continue'
    expect(page).to have_content 'Patterns of Harmful Thoughts'
    click_on 'Continue'
    expect(page).to have_content 'Examples of Patterns'
    click_on 'Continue'
    expect(page).to have_content 'Your Turn'

    click_on 'Continue'
    expect(page).to have_content "Let's start by"

    if page.has_text?("You haven't listed any negative thoughts")
      click_on 'Continue'

    else
      select 'Personalization', :from => 'thought_pattern_id'
      click_on 'Continue'
    end

    if page.has_content?("One thought you had:")
      select 'Magnifying or Minimizing', :from => 'thought_pattern_id'
      click_on 'Continue'

    else

      if page.has_content?("One thought you had:")
        select 'Magnifying or Minimizing', :from => 'thought_pattern_id'
        click_on 'Continue'
        expect(page).to have_content 'Good work!'
        click_on 'Continue'
        expect(page).to have_content 'Add a New Harmful Thought'

      else
        expect(page).to have_content 'Good work!'
        click_on 'Continue'
        expect(page).to have_content 'Add a New Harmful Thought'
      end
    end
  end

  #Testing the #3-Reshape portion of the THINK tool
  it "- reshape" do
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'
    click_on 'Continue'
    if page.has_text?("You don't have any harmful thoughts that you've logged and haven't challenged.")
      click_on 'THINK'
      find(:xpath, ".//*[@id='navbar-collapse']/ul[1]/li[2]/ul/li[1]/a")
      expect(page).to have_content 'Add a New Harmful Thought'
    else
      expect(page).to have_content 'You said you had the following unhelpful thoughts:'
      click_on 'Continue'
      expect(page).to have_content 'Challenging a thought means'
      click_on 'Continue'
      expect(page).to have_content 'You said that you thought...'

      click_on 'Continue'
      expect(page).to have_content 'Come up with a challenging'
      fill_in 'thought[challenging_thought]', :with => 'Example challenge'

      click_on 'Continue'
      expect(page).to have_content 'Thought saved'
      expect(page).to have_content 'Because what you THINK, FEEL, Do'

      click_on 'Continue'
      expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
      fill_in 'thought_act_as_if', :with => 'Example act-as-if'

      click_on 'Continue'
      expect(page).to have_content 'Thought saved'
      expect(page).to have_content 'You said that you thought...'

      click_on 'Continue'
      expect(page).to have_content 'Come up with a challenging'
      fill_in 'thought[challenging_thought]', :with => 'Example challenge'

      click_on 'Continue'
      expect(page).to have_content 'Thought saved'
      expect(page).to have_content 'Because what you THINK, FEEL, Do'

      click_on 'Continue'
      expect(page).to have_content 'What could you do to ACT AS IF you believe this?'
      fill_in 'thought_act_as_if', :with => 'Example act-as-if'

      click_on 'Continue'
      expect(page).to have_content 'Thought saved'
    end
  end

  #Testing the Add a New Thought portion of the THINK tool
  it "- add a new thought" do
    click_on 'Add a New Harmful Thought'
    expect(page).to have_content 'Add a New Harmful Thought'
    fill_in 'thought_content', :with => 'Testing add a new thought'
    select 'Magnifying or Minimizing', :from => 'thought_pattern_id'
    fill_in 'thought_challenging_thought', :with => 'Testing challenge thought'
    fill_in 'thought_act_as_if', :with => 'Testing act-as-if action'

    click_on 'Continue'
    expect(page).to have_content 'Thought saved'
    click_on 'Continue'
    expect(page).to have_content 'Add a New Harmful Thought'
  end

  #Testing the Cancel button in Add a New Thought
  it "- add a new thought, cancel" do
    click_on 'Add a New Harmful Thought'
    expect(page).to have_content 'Add a New Harmful Thought'

    click_on 'Cancel'
    expect(page).to have_content '#1 Identifying'
  end

  #Testing the Thoughts portion of the THINK tool
  it "- check thoughts" do
    click_on 'Thoughts'
    expect(page).to have_content 'Harmful Thoughts'
    expect(page).to have_content 'Example thought 1'
  end

  #Testing the skip functionality in the first slideshows of the first three portions of the THINK tool
  it "- skip functionality" do
    click_on '#1 Identifying'
    expect(page).to have_content 'You are what you think...'
    click_on 'Skip'
    expect(page).to have_content 'Now, your turn...'

    click_on 'THINK'
    click_on 'THINK Home'
    click_on '#2 Patterns'
    expect(page).to have_content 'Thinking Patterns'
    click_on 'Skip'
    expect(page).to have_content "Let's start by figuring out which thought patterns the harmful thoughts you
    identified might match."

    click_on 'THINK'
    click_on 'THINK Home'
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'
    click_on 'Skip'

    if page.has_text?('You said you had')
      expect(page).to have_content "In case you've forgotten"

    else
      expect(page).to have_content "You don't have"
    end
  end

  #Testing navbar functionality specifically surrounding the THINK tool
  it "- navbar functionality" do
    click_on 'THINK'
    click_on 'THINK Home'
    expect(page).to have_content 'Add a New Harmful Thought'

    within("#navbar-collapse") do
      click_on 'THINK'
      click_on '#1 Identifying'
    end
    expect(page).to have_content 'You are what you think...'

    click_on 'THINK'
    click_on '#2 Patterns'
    expect(page).to have_content 'Thinking Patterns'

    click_on 'THINK'
    click_on '#3 Reshape'
    expect(page).to have_content 'Challenging Harmful Thoughts'

    click_on 'THINK'
    click_on 'Add a New Harmful Thought'
    expect(page).to have_content 'Add a New Harmful Thought'

    click_on 'THINK'
    click_on 'Thoughts'
    expect(page).to have_content 'Harmful Thoughts'
  end


  #Testing the THINK tool visualization
  it "- visualization" do
    if page.has_text?('Click a bubble for more info')
      find('.thoughtviz_text.viz-clickable', :text => 'Magnifying or Minimizing').click
      expect(page).to have_content 'Click a bubble for more info'

      find('.thoughtviz_text.viz-clickable', :text => 'Magnifying or Minimizing').click
      expect(page).to have_content "Some Thoughts You've Entered"
      expect(page).to have_content 'Example thought 1'

      click_on 'Close'
      expect(page).to have_content 'Click a bubble for more info'

    else
      expect(page).to have_content 'Thoughts'
    end
  end
end
