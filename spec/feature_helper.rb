# filename: feature_helper.rb

def sign_in_pt(participant, password)
  visit "#{ENV['Base_URL']}/participants/sign_in"
  within('#new_participant') do
    fill_in 'participant_email', with: participant
    fill_in 'participant_password', with: password
  end

  click_on 'Sign in'
end

def sign_in_user(user, password)
  visit "#{ENV['Base_URL']}/users/sign_in"
  within('#new_user') do
    fill_in 'user_email', with: user
    fill_in 'user_password', with: password
  end

  click_on 'Sign in'
end

def choose_rating(element_id, value)
  find("##{ element_id } select").find(:xpath,
                                       "option[#{(value + 1)}]").select_option
end

def compare_thought(thought)
  click_on 'Next'
  expect(page).to have_content 'Thought saved'
  within('.panel-body.adjusted-list-group-item') do
    expect(page).to_not have_content thought
  end

  page.find('.panel-body.adjusted-list-group-item').text
end

def select_patient(patient)
  within('#patients', text: patient) do
    click_on patient
  end
end
