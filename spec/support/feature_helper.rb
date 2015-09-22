# filename: feature_helper.rb

def sign_in_pt(new_participant, old_participant, password)
  visit "#{ENV['Base_URL']}/participants/sign_in"
  if ENV['safari'] && page.has_css?('.navbar-collapse', text: old_participant)
    sign_out(old_participant)
  end
  if page.has_css?('#new_participant')
    within('#new_participant') do
      fill_in 'participant_email', with: new_participant
      fill_in 'participant_password', with: password
    end
    click_on 'Sign in'
    expect(page).to have_content 'HOME'
  else
    puts 'LOGIN FAILED'
  end
end

def sign_in_user(user, old_user, password)
  visit "#{ENV['Base_URL']}/users/sign_in"
  if ENV['safari'] && page.has_css?('.navbar-collapse', text: 'Sign Out')
    sign_out(old_user)
  end
  if page.has_css?('#new_user')
    within('#new_user') do
      fill_in 'user_email', with: user
      fill_in 'user_password', with: password
    end
    click_on 'Sign in'
    expect(page).to have_content 'Home'
  end
end

def sign_out(display_name)
  within('.navbar-collapse') do
    unless page.has_text?('Sign Out')
      click_on display_name
    end

    click_on 'Sign Out'
  end

  expect(page).to have_content 'Forgot your password?'
end

def choose_rating(element_id, value)
  find("##{ element_id } select")
    .find(:xpath, "option[#{(value + 1)}]").select_option
end

def compare_thought(thought)
  accept_social
  expect(page).to have_content 'Thought saved'
  within('.panel-body.adjusted-list-group-item') do
    expect(page).to_not have_content thought
  end

  find('.panel-body.adjusted-list-group-item').text
end

def reshape(challenge, action)
  expect(page).to have_content 'You said that you thought...'
  click_on 'Next'
  fill_in 'thought[challenging_thought]', with: challenge
  click_on 'Next'
  expect(page).to have_content 'Thought saved'

  expect(page).to have_content 'Because what you THINK, FEEL, Do'

  page.execute_script('window.scrollTo(0,5000)')
  click_on 'Next'
  expect(page).to have_content 'What could you do to ACT AS IF you believe ' \
                               'this?'

  fill_in 'thought_act_as_if', with: action
  click_on 'Next'
  expect(page).to have_content 'Thought saved'
end

def pick_tomorrow
  tomorrow = Date.today + 1
  within('#ui-datepicker-div') do
    if page.has_css?('.ui-datepicker-unselectable.ui-state-disabled',
                     text: "#{tomorrow.strftime('%-e')}")
      find('.ui-datepicker-next.ui-corner-all').click
    end

    click_on tomorrow.strftime('%-e')
  end
end

def select_patient(patient)
  within('#patients', text: patient) do
    click_on patient
  end
end

def find_feed_item(item)
  counter = 0
  while page.has_no_css?('.list-group-item.ng-scope',
                         text: item) && counter < 15
    page.execute_script('window.scrollTo(0,100000)')
    counter += 1
  end
end

def accept_social
  page.driver.execute_script('window.confirm = function() {return true}')
  click_on 'Next'
end

def check_data(item, data)
  within(item) do
    expect(page).to have_content data
  end
end

def go_to_next_page(module_text)
  unless page.has_text? module_text
    page.execute_script('window.scrollTo(0,5000)')
    within('.pagination') do
      click_on '2'
    end
  end
end

def answer_profile_question(question, id, answer)
  within('.panel.panel-default.ng-scope', text: question) do
    fill_in "new-answer-description-#{id}", with: answer
    click_on 'Save'
  end
end
