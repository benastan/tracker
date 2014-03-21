require 'spec_helper'

feature 'Stories' do
  let(:epic_story) { create :story, title: 'Epic Story' }
  let(:middle_story) { create :story, title: 'Middle Story' }
  let(:unblocked_story) { create :story, title: 'Unblocked Story' }
  let!(:standalone_story) { create :story, title: 'Standalone Story' }

  before do
    epic_story.child_stories << middle_story

    middle_story.child_stories << unblocked_story

    visit root_path
  end

  scenario 'creating a story' do
    visit new_story_path

    fill_in 'story_title', with: 'Hello, World'

    click_on 'Create Story'

    page.should have_content 'Hello, World'
  end

  scenario 'click through to story' do
    click_on 'Unblocked Story'

    page.should have_css '#show_story > h3', text: 'Unblocked Story'
  end

  scenario 'show story', js: true do
    middle_story.child_stories << create(:story, title: 'Middle Story Child')
    
    visit story_path(middle_story)

    page.should have_css '.story > h4', text: 'Unblocked Story'

    all('.story')[1].drag_to first('.story > h4')
    
    page.should_not have_css '.story > h4', text: 'Middle Story Child'
  end

  scenario 'nesting a story by draging', js: true do
    first_story = find("#story_#{unblocked_story.id}")
    
    second_story = find("#story_#{standalone_story.id}")

    first_story.drag_to(second_story.find('h4'))

    page.should have_css '.story > h4', text: 'Standalone Story'
  end

#   scenario 'sorting a story by draging', js: true do
#     stories = all('#stories_index > .story')

#     first_story = stories.first
    
#     second_story = stories[1]

#     last_story = stories.last

#     sleep 2

#     last_story.drag_to(second_story)

#     sleep 2

#     page.evaluate_script("$('##{last_story[:id]}').triggerHandler('sortupdate');");
    
#     page.should have_css('.fa-check')
    
#     sleep 2

#     visit root_path

#     stories = all('#stories_index > .story')

#     sleep 2

#     stories[1].should have_content new_child_story.title
#   end

end