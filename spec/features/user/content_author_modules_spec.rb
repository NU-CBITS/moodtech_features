# filename: content_author_modules_spec.rb

describe 'Content Author signs in, visits Content Modules tool,',
         type: :feature, sauce: sauce_labs do
  before do
    unless ENV['safari']
      sign_in_user(ENV['Content_Author_Email'], 'TFD Moderator',
                   ENV['Content_Author_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
    click_on 'Arm 1'
    click_on 'Manage Content'
    click_on 'Content Modules'
  end

  it 'creates a new module' do
    click_on 'New'
    fill_in 'content_module_title', with: 'Test content module'
    select 'THINK', from: 'content_module_bit_core_tool_id'
    fill_in 'content_module_position', with: '8'
    click_on 'Create'
    expect(page).to have_content 'Content module was successfully created.'
  end

  it 'edits a module' do
    expect(page).to have_content 'Listing Content Modules'

    page.execute_script('window.scrollTo(0,5000)')
    click_on '#1 Awareness'
    click_on 'Edit'
    select 'THINK', from: 'content_module_bit_core_tool_id'
    fill_in 'content_module_position', with: '9'
    click_on 'Update'
    expect(page).to have_content 'Content module was successfully updated.'

    expect(page).to have_content 'Tool: THINK'

    click_on 'Edit'
    select 'DO', from: 'content_module_bit_core_tool_id'
    fill_in 'content_module_position', with: '2'
    click_on 'Update'
    expect(page).to have_content 'Content module was successfully updated.'

    expect(page).to have_content 'Tool: DO'
  end

  it 'destroys a module' do
    unless page.has_text? 'Test content module'
      go_to_next_page
    end

    click_on 'Test content module'
    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'Content module along with any associated ' \
                                 'tasks were successfully destroyed.'

    expect(page).to_not have_content 'Test content module'
  end

  it 'creates a provider' do
    find('h1', text: 'Listing Content Modules')
    page.execute_script('window.scrollTo(0,5000)')
    unless page.has_text? 'Home Introduction'
      go_to_next_page
    end

    click_on 'Home Introduction'

    click_on 'New Provider'
    within '#content_provider_bit_core_content_module_id' do
      expect(page).to have_content 'LEARN: Home Introduction'
    end

    select 'slideshow provider', from: 'content_provider_type'
    select 'BitCore::Slideshow', from: 'content_provider_source_content_type'
    select 'Home Intro', from: 'content_provider_source_content_id'
    fill_in 'content_provider_position', with: '4'
    check 'content_provider_show_next_nav'
    check 'content_provider_is_skippable_after_first_viewing'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Create'
    expect(page).to have_content 'ContentProvider was successfully created.'
    expect(page).to have_content "Tool: LEARN\nModule: Home Introduction" \
                                 "\nPosition: 4 / 4\nIs skippable after first" \
                                 " viewing: true\nSlideshow: Home Intro"
  end

  it 'updates a provider' do
    find('h1', text: 'Listing Content Modules')
    page.execute_script('window.scrollTo(0,5000)')
    unless page.has_text? 'Home Introduction'
      go_to_next_page
    end

    click_on 'Home Introduction'
    click_on '1 slideshow provider'
    expect(page).to have_content 'Is skippable after first viewing: false'

    click_on 'Edit'
    fill_in 'content_provider[position]', with: '10'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Update'
    expect(page).to have_content 'ContentProvider was successfully updated.'

    expect(page).to have_content 'Position: 10 / 10'

    click_on 'Edit'
    fill_in 'content_provider[position]', with: '1'
    page.execute_script('window.scrollTo(0,5000)')
    click_on 'Update'
    expect(page).to have_content 'ContentProvider was successfully updated.'

    unless page.has_text? 'Position: 1 / 4'
      expect(page).to have_content 'Position: 1 / 1'
    end
  end

  it 'destroys a provider' do
    find('h1', text: 'Listing Content Modules')
    page.execute_script('window.scrollTo(0,5000)')
    unless page.has_text? 'Home Introduction'
      go_to_next_page
    end

    click_on 'Home Introduction'
    click_on '4 slideshow provider'
    expect(page).to have_content 'Slideshow: Home Intro'

    page.driver.execute_script('window.confirm = function() {return true}')
    click_on 'Destroy'
    expect(page).to have_content 'Content Providers'
  end

  it 'uses breadcrumbs to return home' do
    expect(page).to have_content 'New'
    click_on 'Arm'
    within('.breadcrumb') do
      click_on 'Arms'
    end

    expect(page).to have_content 'Arm 2'

    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content "Arms\nNavigate to groups and participants " \
                                 'through arms.'
  end
end
