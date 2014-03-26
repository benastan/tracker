require 'spec_helper'

describe StoriesController do
  it do
    should route(:get, '/stories/new').to(action: :new)
  end

  it do
    should route(:post, '/stories').to(action: :create)
  end

  it do
    should route(:get, '/stories/1').to(action: :show, id: '1')
  end

  it do
    should route(:patch, '/stories/1').to(action: :update, id: '1')
  end

  it do
    should route(:delete, '/stories/1').to(action: :destroy, id: '1')
  end

  describe '#index' do
    let(:fake_stories_relation) do
      double 'stories',
        to_json: '"all"',
        unblocked: :unblocked,
        epic: :epic
    end

    let!(:fake_story_order) do
      double 'story_order',
        stories: fake_stories_relation
    end
    
    before do
      StoryOrder.stub(:first_or_create) { fake_story_order }
    end

    context 'when the format is json' do
      specify do
        get(:index, format: :json, unblocked: true)

        response.body.should == '"unblocked"'
      end
      
      specify do
        get(:index, format: :json, epic: true)

        response.body.should == '"epic"'
      end
      
      specify do
        get(:index, format: :json)

        response.body.should == '"all"'
      end
    end

    context 'when the format is html' do
      it 'orders on the default StoryOrder' do
        get(:index)
        
        assigns[:unblocked_stories].should == :unblocked
        assigns[:epic_stories].should == :epic
      end
    end
  end

  describe '#new' do
    specify do
      get(:new)

      assigns(:story).should be_a Story
    end

    specify do
      get(:new)
      
      assigns(:story).should_not be_persisted
    end

    specify do
      get(:new).should be_ok
    end
  end

  describe '#create' do
    def post_create
      post :create,
        story: {
          title: 'My First Story'
        }
    end

    specify do
      post_create.should redirect_to Story.last
    end
    
    specify do
      expect do
        post_create
      end.to change(Story, :count).by(1)
    end
  end

  describe '#show' do
    let(:fake_hash) do
      double 'serializable_hash',
        to_json: :shmargis
    end

    let(:child_story_stories) do
      double 'child story stories'
    end

    let(:fake_story) do
      double 'story',
        serializable_hash: fake_hash,
        parent_stories: 'kiddo',
        child_story_stories: child_story_stories
    end

    before do
      Story.stub(:find) { fake_story }

      child_story_stories.stub(
        child_unstarted: double(
          child_unfinished: double(
            child_unclosed: 'unstarted children'
          )
        ),
        child_started: double(
          child_unfinished: double(
            child_unclosed: 'started children'
          ),
          child_finished: double(
            child_unclosed: 'finished children',
            child_closed: 'closed children'
          )
        )
      )
    end

    context 'when the format is html' do
      let!(:new_story_story) do
        StoryStory.new
      end
      
      let!(:new_story) do
        Story.new
      end

      before do
        StoryStory.stub(new: new_story_story)

        Story.stub(new: new_story)
      end

      specify do
        get(:show, id: 'asdfasdfa').should be_ok
      end

      specify do
        get(:show, id: 'asgdsagsa')

        assigns(:story).should == fake_story
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:parent_stories).should == 'kiddo'
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:unstarted_child_story_stories).should == 'unstarted children'
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:started_child_story_stories).should == 'started children'
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:finished_child_story_stories).should == 'finished children'
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:closed_child_story_stories).should == 'closed children'
      end

      specify do
        get(:show, id: 'asdfasdfa')

        assigns(:story_story).should == new_story_story
      end

      specify do
        get(:show, id: 'asdfasdfa')

        StoryStory.should have_received(:new).with(
          parent_story: fake_story,
          child_story: new_story
        )
      end
    end

    context 'when the format is json' do
      specify do
        fake_story.should_receive(:serializable_hash).with(includes: [ :child_stories, :parent_stories ])

        get(:show, id: 'asdfas', format: :json)
      end

      specify do
        get(:show, id: 'asdfas', format: :json).body.should == "shmargis"
      end
    end
  end

  describe 'PATCH update' do
    let(:story) do
      build :story
    end

    before do
      story.stub(
        update_attributes: true,
        id: 1
      )

      Story.stub(find: story)
    end

    specify do
      story_attributes = {
        title: 'some title',
        started_at: 'right now',
        finished_at: 'left now',
        closed_at: 'down now'
      }

      patch(:update, id: 1, story: story_attributes)

      story.should have_received(:update_attributes).with(
        'title' => 'some title',
        'started_at' => 'right now',
        'finished_at' => 'left now',
        'closed_at' => 'down now'
      )
    end

    specify do
      patch(:update, id: 1, story: { title: 'some title' }).should redirect_to story
    end
  end

  describe 'DELETE destroy' do
    let(:story) do
      double 'story',
        destroy!: true
    end
    
    before do
      Story.stub(find: story)
    end

    specify do
      delete(:destroy, id: 1)

      story.should have_received(:destroy!)
    end
  end
end
