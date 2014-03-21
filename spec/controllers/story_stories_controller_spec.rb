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
    should route(:get, '/stories/1/child_stories/new').to(
      controller: 'story_stories',
      action: 'new',
      story_id: '1')
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
        story_story: story_story_attributes,
        format: :json
    end

    context 'when a story_story_id is provided' do
      let(:story_story_attributes) do
        {
          parent_story_id: parent_story.id,
          child_story_id: child_story.id
        }
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
    
    context 'when story_story_attributes are provided' do
      let(:child_story_attributes) do
        FactoryGirl.attributes_for(:story)
      end
      
      let(:story_story_attributes) do
        {
          parent_story_id: parent_story.id,
          child_story_attributes: child_story_attributes
        }
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
    end
  end

  describe '#new' do
    let!(:parent_story) do
      create :story
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
  end
end