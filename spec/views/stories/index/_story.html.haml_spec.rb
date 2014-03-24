require 'spec_helper'

describe 'stories/index/_story.html.haml' do
  let(:story) { create :story, title: 'My Story' }

  before do
    view.stub(:story) { story }
  end

  specify { render.should have_xpath "//div[@data-id='#{story.id}']" }

  specify { render.should have_xpath "//div[@data-title='#{story.title}']" }

  specify { render.should have_xpath "//div[@id='story_#{story.id}']/h4", text: 'My Story' }
  
  specify { render.should have_css '#story_story_parent_story_id' }
  
  specify { render.should have_css '#story_story_child_story_id' }
  
  specify { render.should have_css 'input[type="submit"][value="Add Child Story"]' }

  specify { render.should_not have_css '.story_parent_stories li.story' }

  specify { render.should_not have_css '.story_child_stories li.story' }

  context 'when the story has parents' do
    let!(:parent_story) { story.parent_stories.create(attributes_for(:story, title: 'Parent')) }

    specify { render.should have_css '.story_parent_stories li.story', text: 'Parent' }

    specify { render.should_not have_css '.story_child_stories li.story' }
  end

  context 'when the story has children' do
    let!(:child_story) { story.child_stories.create(attributes_for(:story, title: 'Child')) }

    specify { render.should have_css '.story_child_stories li.story', text: 'Child' }

    specify { render.should_not have_css '.story_parent_stories li.story' }
  end
end