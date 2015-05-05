# filename: feature_helper.rb

def sign_in_pt(participant, password)
  visit "#{ENV['Base_URL']}/participants/sign_in"
  if page.has_css?('#new_participant')
    within('#new_participant') do
      fill_in 'participant_email', with: participant
      fill_in 'participant_password', with: password
    end

    click_on 'Sign in'
  end
end

def sign_in_user(user, password)
  visit "#{ENV['Base_URL']}/users/sign_in"
  if page.has_css?('#new_user')
    within('#new_user') do
      fill_in 'user_email', with: user
      fill_in 'user_password', with: password
    end

    click_on 'Sign in'
  end
end

def choose_rating(element_id, value)
  find("##{ element_id } select")
    .find(:xpath, "option[#{(value + 1)}]").select_option
end

def compare_thought(thought)
  click_on 'Next'
  page.accept_alert 'Are you sure that you would like to make these public?'
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
