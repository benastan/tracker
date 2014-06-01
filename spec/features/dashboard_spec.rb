require 'spec_helper'

feature 'dashboard' do
  let(:epic_story) do
    create :story, title: 'Epic Story'
  end

  let(:middle_story) do
    create :story, title: 'Middle Story'
  end

  let(:unblocked_story) do
    create :story, title: 'Unblocked Story'
  end

  let!(:standalone_story) do
    create :story, title: 'Standalone Story'
  end
  
  before do
    epic_story.child_stories << middle_story

    middle_story.child_stories << unblocked_story

    visit root_path
  end

  scenario 'creating a story' do
    visit root_path

    click_on 'New Story'

    fill_in 'story_title', with: 'Hello, World'

    click_on 'Create Story'
    
    click_on 'New Story'

    fill_in 'story_title', with: 'Give me a child'

    click_on 'Create Story'

    parent_story = Story.last

    click_on 'Hello, World'
    
    fill_in 'story_story_child_story_attributes_title', with: 'Hello, Globe'

    click_on 'Create Story'

    page.should have_content 'Hello, Globe'

    first('.story_menu_toggle').click

    click_on 'Move'

    choose(all('input[type="radio"]').last['id'])

    click_on "Move Story"

    page.should have_content "Hello, Globe"
    
    click_on "Give me a child"

    fill_in 'story_title', with: 'Now I have a child!'

    click_on 'Save'

    page.should have_css '#story_title[value="Now I have a child!"]'

    first('.story_menu_toggle').click

    first(:link, 'Unnest story').click

    first(:link, 'Now I have a child!').click

    page.should_not have_css '#show_story .story', text: 'Hello, Globe'

    click_on 'Start'

    click_on 'Finish'
    
    click_on 'Close'

    click_on 'Closed'

    page.should have_css 'button', text: 'Start'

    click_on 'Move Story'
    
    choose(all('input[type="radio"]').last['id'])

    click_on "Move Story"

    click_on 'Delete Story'

    page.should_not have_content 'Now I have a child!'
  end
end
