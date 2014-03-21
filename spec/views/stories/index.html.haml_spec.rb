require 'spec_helper'

describe 'stories/index.html.haml' do
  let(:unblocked_story) { FactoryGirl.build(:story, id: 1, title: 'Some Unblocked Story') }
  
  let(:epic_story) { FactoryGirl.build(:story, id: 2, title: 'Some Unblocked Story') }
  
  before do
    assign :unblocked_stories, [ unblocked_story ]
    
    assign :epic_stories, [ epic_story ]
  end

  specify { render.should have_css '#stories_index', text: 'Blah' }
end