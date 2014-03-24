require 'spec_helper'

describe 'shared/stories/_sidebar.html.haml' do
  let(:started_at) { nil }

  let(:finished_at) { nil }

  let(:closed_at) { nil }

  let(:unblocked_story) do
    FactoryGirl.build :story,
      id: 1,
      title: 'Some Unblocked Story',
      started_at: Time.new,
      finished_at: finished_at,
      closed_at: closed_at
  end
  
  let(:epic_story) do
    FactoryGirl.build :story,
      id: 2,
      title: 'Some Unblocked Story',
      started_at: started_at
  end
  
  before do
    assign :unblocked_stories, [ unblocked_story ]
    
    assign :epic_stories, [ epic_story ]

    render
  end

  specify { rendered.should have_css '#stories_sidebar a', text: 'New Story' }

  specify { rendered.should have_link 'New Story', href: new_story_path }
  
  specify { rendered.should have_css '#stories_sidebar' }
  
  specify { rendered.should have_css '#stories_sidebar .sidebar_content' }

  describe 'stories list' do
    specify { rendered.should have_css '.sidebar_content li h2', text: 'Epic' }

    context 'when a story is unstarted' do
      specify { rendered.should_not have_css '#story_2 i.fa-circle.green' }
      
      specify { rendered.should_not have_css '#story_2 i.fa-circle.yellow' }
    end
    
    context 'when a story is started but not finished' do
      let(:started_at) { Time.new }

      specify { rendered.should have_css '#story_2 i.fa-circle.green' }
      
      specify { rendered.should_not have_css '#story_2 i.fa-circle.yellow' }
    end
    
    context 'when a story is started and finished' do
      let(:finished_at) { Time.new }

      specify { rendered.should_not have_css '#story_1 i.fa-circle.green' }
      
      specify { rendered.should have_css '#story_1 i.fa-circle.yellow' }
    end
        
    context 'when a story is started, finished and closed' do
      let(:finished_at) { Time.new }

      let(:closed_at) { Time.new }
      
      specify { rendered.should_not have_css '#story_1 i.fa-circle.green' }
      
      specify { rendered.should_not have_css '#story_1 i.fa-circle.yellow' }
    end
    
    specify { rendered.should have_css '.sidebar_content li h2', text: 'Unblocked' }
    
    specify { rendered.should have_css '.sidebar_content li ul', count: 2 }
    
    specify { rendered.should have_css '#epic_stories_list li', count: 1 }

    specify { rendered.should have_css '#unblocked_stories_list li', count: 1 }
  end
end