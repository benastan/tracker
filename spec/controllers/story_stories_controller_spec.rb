require 'spec_helper'

describe StoryStoriesController do
  it do
    should route(:post, '/story_stories.json').to(
      controller: 'story_stories',
      action: 'create',
      format: 'json')
  end

  it do
    should route(:get, '/story_stories/1.json').to(
      controller: 'story_stories',
      action: 'show',
      id: '1',
      format: 'json')
  end

  it do
    should route(:delete, '/story_stories/1').to(
      controller: 'story_stories',
      action: 'destroy',
      id: '1')
  end

  describe '#create' do
    let!(:parent_story) do
      create :story
    end

    let!(:child_story) do
      create :story
    end

    def post_create
      post :create,
        story_story: story_story_attributes
    end

    let(:child_story_attributes) do
      FactoryGirl.attributes_for(:story)
    end

    let(:story_story_attributes) do
      {
        parent_story_id: parent_story.id,
        child_story_attributes: child_story_attributes
      }
    end

    before do
      allow(UpdateStoriesMinEpicParentStoryEpicOrder).to receive(:perform).and_return(nil)
    end

    specify do
      expect do
        post_create
      end.to change(parent_story.child_stories, :count).by(1)
    end

    specify do
      expect do
        post_create
      end.to change { Story.count }.by(1)
    end

    specify do
      post_create
      expect(UpdateStoriesMinEpicParentStoryEpicOrder).to have_received(:perform)
    end
  end

  describe '#destroy' do
    let(:parent_story) do
      create :story
    end

    let(:child_story) do
      create :story
    end

    let!(:story_story) do
      StoryStory.create(
        parent_story: parent_story,
        child_story: child_story
      )
    end

    before do
      allow(UpdateStoriesMinEpicParentStoryEpicOrder).to receive(:perform).and_return(nil)
    end

    specify do
      delete(:destroy, id: story_story.id).should redirect_to :root
    end

    specify do
      delete(:destroy, id: story_story.id)

      expect do
        StoryStory.find(story_story.id)
      end.to raise_error
    end

    specify do
      expect do
        delete(:destroy, id: story_story.id)
      end.to change { StoryStory.count }.by(-1)
    end

    specify do
      delete(:destroy, id: story_story.id)
      expect(UpdateStoriesMinEpicParentStoryEpicOrder).to have_received(:perform)
    end
  end
end
