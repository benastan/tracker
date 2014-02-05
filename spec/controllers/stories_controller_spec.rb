require 'spec_helper'

describe StoriesController do
  it { should route(:get, '/stories/new').to(controller: :stories, action: :new) }
  it { should route(:post, '/stories').to(controller: :stories, action: :create) }
  
  describe '#index' do
    specify do
      get(:index)
      assigns[:stories].should == StoryOrder.first.stories
    end
  end

  describe '#new' do
    def get_new
      get(:new)
    end

    specify do
      get_new
      assigns[:story].should be_a Story
      assigns[:story].should_not be_persisted
    end

  specify { get_new.should be_ok }
  end

  describe '#create' do
    def post_create
      post(:create, story: { title: 'My First Story' })
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
end
