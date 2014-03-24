require 'spec_helper'

describe 'stories/show.html.haml' do
  let(:child_story_stories) { [] }

  let(:story) do
    create :story,
      title: 'Story'
  end

  let(:child_story) do
    create :story,
      title: "Child Story"
  end

  let(:child_story_story) do
    story.child_story_stories.create(
      child_story: child_story 
    )
  end

  let(:story_story) do
    StoryStory.new(
      parent_story: story,
      child_story: Story.new
    )
  end

  before do
    assign :child_story_stories, child_story_stories
    
    assign :story, story
    
    assign :story_story, story_story

    render
  end

  specify do
    rendered.should have_css '#show_story'
  end
  
  specify do
    rendered.should have_css 'h3', text: 'Story'
  end
  
  context 'when there are no child stories' do
    specify do
      rendered.should_not have_css 'h4', text: 'Sub-stories'
    end
  end

  context 'when there are child stories' do
    let(:child_story_stories) do
      [ child_story_story ]
    end

    specify do
      rendered.should have_css 'h4', text: 'Inbox'
    end

    specify do
      rendered.should have_link "#{child_story.id}", href: url_for(child_story)
    end

    specify do
      rendered.should have_css '.story', count: 1
    end

    specify do
      rendered.should have_css '.story h5', count: 1, text: 'Child Story'
    end

    specify do
      rendered.should have_css 'a.story_menu_toggle .fa-sort-asc'
    end

    specify do
      rendered.should have_link "Unnest Child", href: url_for(child_story_story)
    end
  end

  describe 'child story form' do
    specify do
      rendered.should have_css 'h4', text: 'Add Sub-story'
    end

    specify do
      rendered.should have_css '#new_story_story'
    end
  end
end
