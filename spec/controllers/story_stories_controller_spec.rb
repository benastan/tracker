require 'spec_helper'

describe StoryStoriesController do
  it { should route(:post, '/story_stories.json').to(controller: 'story_stories', action: 'create', format: 'json') }
  it { should route(:get, '/story_stories/1.json').to(controller: 'story_stories', action: 'show', id: '1', format: 'json') }

  describe '#create' do
    let(:parent_story) { create :story }
    let(:child_story) { create :story }

    def post_create
      post :create, story_story: { parent_story_id: parent_story.id, child_story_id: child_story.id }, format: :json
    end

    specify do
      expect do
        post_create
      end.to change(parent_story.child_stories, :count).by(1)
    end

    specify do
      expect do
        post_create
      end.to change(child_story.parent_stories, :count).by(1)
    end

    specify { post_create.code.should == '201' }

    specify { post_create.body.should == StoryStory.last.to_json }
  end
end
