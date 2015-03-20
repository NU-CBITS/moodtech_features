# filename: content_author_lessons_spec.rb

describe 'Content Author signs in and navigates to Lesson Modules tool',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_user(ENV['Content_Author_Email'], ENV['Content_Author_Password'])
    click_on 'Arms'
    find('h1', text: 'Arms')
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Lesson Modules'
  end

  it 'creates a new lesson' do
    click_on 'New'
    fill_in 'lesson_title', with: 'Test lesson'
    fill_in 'lesson_position', with: '19'
    click_on 'Create'
    expect(page).to have_content 'Successfully created lesson'
  end

  it 'updates title of a lesson' do
    click_on 'Do - Awareness Introduction'
    expect(page).to have_content 'This is just the beginning...'

    page.all(:link, 'Edit')[0].click
    fill_in 'lesson_title', with: 'Do - Awareness Introduction 123'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'

    expect(page).to have_content 'Do - Awareness Introduction 123'

    page.all(:link, 'Edit')[0].click
    fill_in 'lesson_title', with: 'Do - Awareness Introduction'
    click_on 'Update'
    expect(page).to have_content 'Successfully updated lesson'

    expect(page).to have_content 'Do - Awareness Introduction'
  end

  # this example is commented out as it fails most runs
  # drag_to doesn't play nice with sortable list
  #
  # it 'updates position of lessons by using drag and drop sorting' do
  #   lesson_value = page.find('tr:nth-child(11)').text
  #   lesson = page.all('.fa.fa-sort.fa-lg')
  #   lesson[11].drag_to(lesson[3])

  #   within('tr:nth-child(3)') do
  #     expect(page).to have_content lesson_value
  #   end
  # end

  it 'destroys lesson' do
    within('tr', text: 'Test lesson') do
      find('.btn.btn-danger').click
    end

    page.accept_alert 'Are you sure?'
    expect(page).to_not have_content 'Test lesson'
  end

  it 'uses breadcrumbs to return home' do
    click_on 'Arm'
    within('.breadcrumb') do
      click_on 'Arms'
    end

    expect(page).to have_content 'Arm 2'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
