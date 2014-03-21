require 'spec_helper'

describe 'shared/stories/_sidebar.html.haml' do
  let(:story) { nil }

  let(:unblocked_story) { FactoryGirl.build(:story, id: 1, title: 'Some Unblocked Story') }
  
  let(:epic_story) { FactoryGirl.build(:story, id: 2, title: 'Some Unblocked Story') }
  
  before do
    assign :story, story

    assign :unblocked_stories, [ unblocked_story ]
    
    assign :epic_stories, [ epic_story ]

    render
  end

  specify { render.should have_css '#stories_sidebar a', text: 'New Story' }

  specify { render.should have_link 'New Story', href: new_story_path }
  
  specify { render.should have_css '#stories_sidebar' }
  
  specify { render.should have_css '#stories_sidebar .sidebar_content' }

  describe 'stories list' do
    specify { render.should have_css '.sidebar_content li h2', text: 'Epic' }
    
    specify { render.should have_css '.sidebar_content li h2', text: 'Unblocked' }
    
    specify { render.should have_css '.sidebar_content li ul', count: 2 }
    
    specify { render.should have_css '#epic_stories_list li', count: 1 }

    specify { render.should have_css '#unblocked_stories_list li', count: 1 }
  end
end