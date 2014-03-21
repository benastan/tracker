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

    page.should have_content 'Hello, World'

    click_on 'Hello, World'

    click_on 'New Sub-story'
    
    fill_in 'story_story_child_story_attributes_title', with: 'Hello, Globe'

    click_on 'Create Story'

    page.should have_content 'Hello, Globe'
  end
end
