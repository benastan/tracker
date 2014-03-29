require 'spec_helper'

describe ChildStoriesController do
  it do
    should route(:get, '/stories/1/child_stories/new').to(
      controller: 'child_stories',
      action: 'new',
      story_id: '1')
  end
  
  describe '#new' do
    let!(:parent_story) do
      create :story
    end

    let(:new_story) do
      build :story
    end

    before do
      Story.stub(new: new_story)
    end
    
    specify do
      get(:new, story_id: parent_story.id).should render_template :new
    end

    specify do
      get(:new, story_id: parent_story.id)

      assigns(:story_story).should be_a StoryStory
    end

    specify do
      get(:new, story_id: parent_story.id)

      assigns(:story_story).parent_story.should == parent_story
    end

    specify do
      get(:new, story_id: parent_story.id)

      assigns(:story_story).child_story.should == new_story
    end
  end
end