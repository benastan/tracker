require 'spec_helper'

describe 'stories/show.html.haml' do
  let(:started_at) { nil }

  let(:finished_at) { nil }

  let(:closed_at) { nil }

  let(:started_child_story_stories) { [] }

  let(:finished_child_story_stories) { [] }

  let(:closed_child_story_stories) { [] }

  let(:unstarted_child_story_stories) { [] }

  let(:story) do
    create :story,
      title: 'Story',
      started_at: started_at,
      finished_at: finished_at,
      closed_at: closed_at
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

  shared_examples_for 'a child story story' do
    specify do
      rendered.should have_link "#{child_story.id}", href: url_for(child_story)
    end

    specify do
      rendered.should have_css '.story', count: 1
    end

    specify do
      rendered.should have_css '.story h5', count: 1, text: child_story.title
    end

    specify do
      rendered.should have_css 'a.story_menu_toggle .fa-sort-asc'
    end

    specify do
      rendered.should have_link "Unnest Child", href: url_for(child_story_story)
    end
  end

  before do
    assign :story, story
    
    assign :story_story, story_story
    
    assign :unstarted_child_story_stories, unstarted_child_story_stories

    assign :started_child_story_stories, started_child_story_stories

    assign :finished_child_story_stories, finished_child_story_stories

    assign :closed_child_story_stories, closed_child_story_stories

    render
  end

  specify do
    rendered.should have_css '#show_story'
  end

  specify do
    rendered.should have_css "#edit_story_#{story.id}"
  end
  specify do
    rendered.should have_css '#story_title[value="Story"]'
  end
  
  specify do
    rendered.should have_css "#edit_story_#{story.id} input[type='submit'][value='Save']"
  end

  specify do
    rendered.should have_css "a[href='#{url_for(story)}'][title='Delete Story'][data-method='delete']"
  end

  context 'when the story is not started' do
    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[started_at]']"
    end

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[finished_at]']"
    end

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[closed_at]']"
    end
  end

  context 'when the story is started and not finished' do
    let(:started_at) { Time.new }

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[started_at]']"
    end

    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[finished_at]']"
    end

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[closed_at]']"
    end
  end

  context 'when the story is started and finished, and not closed' do
    let(:started_at) { Time.new }
    
    let(:finished_at) { Time.new }

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[started_at]']"
    end

    specify do
      rendered.should_not have_css "#edit_story_#{story.id} input[name='story[finished_at]']"
    end

    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[closed_at]']"
    end
  end

  context 'when the story is started, finished and closed' do
    let(:started_at) { Time.new }
    
    let(:finished_at) { Time.new }

    let(:closed_at) { Time.new }

    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[started_at]']"
    end

    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[finished_at]']"
    end

    specify do
      rendered.should have_css "#edit_story_#{story.id} input[name='story[closed_at]']"
    end
  end

  context 'when there are no child stories' do
    specify do
      rendered.should_not have_css 'h4', text: 'Sub-stories'
    end
  end

  context 'when there are child stories' do
    describe 'started stories' do
      context 'when there are no started stories' do
        specify do
          rendered.should_not have_css 'h4', text: 'Started'
        end
      end

      context 'when there are started stories' do
        let(:child_story) do
          mock_model Story,
            title: 'Started Story'
        end

        let(:child_story_story) do  
          mock_model StoryStory,
            child_story: child_story
        end

        let(:started_child_story_stories) do  
          [ child_story_story ]
        end
        
        specify do
          rendered.should have_css 'h4', text: 'Started'
        end

        it_should_behave_like 'a child story story'
      end
    end
    
    describe 'finished stories' do
      context 'when there are no finished stories' do
        specify do
          rendered.should_not have_css 'h4', text: 'Finished'
        end
      end

      context 'when there are finished stories' do
        let(:child_story) do
          mock_model Story,
            title: 'Finished Story'
        end

        let(:child_story_story) do  
          mock_model StoryStory,
            child_story: child_story
        end

        let(:finished_child_story_stories) do  
          [ child_story_story ]
        end
        
        specify do
          rendered.should have_css 'h4', text: 'Finished'
        end

        it_should_behave_like 'a child story story'
      end
    end

    describe 'closed stories' do
      context 'when there are no closed stories' do
        specify do
          rendered.should_not have_css 'h4', text: 'Closed'
        end
      end

      context 'when there are closed stories' do
        let(:child_story) do
          mock_model Story,
            title: 'Closed Story'
        end

        let(:child_story_story) do  
          mock_model StoryStory,
            child_story: child_story
        end

        let(:closed_child_story_stories) do  
          [ child_story_story ]
        end
        
        specify do
          rendered.should have_css 'h4', text: 'Closed'
        end

        it_should_behave_like 'a child story story'
      end
    end

    describe 'unstarted' do
      let(:unstarted_child_story_stories) do
        [ child_story_story ]
      end

      specify do
        rendered.should have_css 'h4', text: 'Unstarted'
      end

      it_should_behave_like 'a child story story'
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
