require 'spec_helper'

describe StoriesController do
  it do
    should route(:get, '/stories/new').to(controller: :stories, action: :new)
  end

  it do
    should route(:post, '/stories').to(controller: :stories, action: :create)
  end

  it do
    should route(:get, '/stories/1').to(controller: :stories, action: :show, id: '1')
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
      post_create.should redirect_to :root
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

    let(:fake_story) do
      double 'story',
        serializable_hash: fake_hash,
        parent_stories: 'kiddo',
        child_stories: 'kid A'
    end

    before do
      Story.stub(:find) { fake_story }
    end

    context 'when the format is html' do
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

        assigns(:child_stories).should == 'kid A'
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
end
