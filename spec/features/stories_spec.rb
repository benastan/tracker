require 'spec_helper'

feature 'Stories' do
  let!(:parent_story) { create :story, title: 'Parent Story' }
  let!(:old_child_story) { create :story, parent_story: parent_story }
  let!(:new_child_story) { create :story, title: 'New Child Story' }

  before do
    visit root_path
  end

  it 'renders each story' do
    within "#story_#{parent_story.id}" do
      within 'ul' do
        page.should have_content old_child_story.title
      end

      within "#new_story_story" do
        page.should_not have_xpath ".//option[@value=\"#{parent_story.id}\"]"
        
        page.should_not have_xpath ".//option[@value=\"#{old_child_story.id}\"]"
      end
    end
  end

  scenario 'creating a story' do
    click_on 'New Story'

    fill_in 'story_title', with: 'Hello, World'

    click_on 'Create Story'

    page.should have_content 'Hello, World'
  end

  scenario 'adding an existing child story', js: true do
    within "#story_#{parent_story.id}" do
      within "#new_story_story" do
        select 'New Child Story', from: 'story_story_child_story_id'

        click_on 'Add Task'

        page.should have_css '.fa-spinner'

        page.should have_css '.fa-check'
      end
      
      page.should_not have_css '.fa-check'
      
      within 'ul' do
        page.should have_content 'New Child Story'
      end
    end
  end

  scenario 'dragging stories around', js: true do
    stories = all('#stories_index > .story')

    last_story = stories.last

    first_story = stories.first

    last_story.drag_to(first_story)
    
    page.evaluate_script("$('##{last_story[:id]}').trigger('sortupdate');");
    
    page.should have_css('.fa-check')

    visit root_path

    stories = all('#stories_index > .story')

    stories[0].should have_content new_child_story.title
  end
end