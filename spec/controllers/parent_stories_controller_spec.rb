require 'spec_helper'

describe ParentStoriesController do
  describe 'routes' do
    it do
      should route(:get, '/stories/1/parent_stories/edit').to(action: :edit, story_id: '1')
    end    
  end

  let(:story) do
    stub_model Story,
      id: 9,
      title: "Story 9"
  end

  describe 'GET #edit' do
    before do
      Story.stub(:find).with('9').and_return(story)

      controller.stub(:parent_stories_collection).with(story).and_return([])
    end

    specify do
      get :edit, story_id: 9

      assigns[:story].should == story
    end

    specify do
      get :edit, story_id: 9

      assigns[:parent_stories].should == []
    end

    specify do
      get(:edit, story_id: 9).should render_template(:edit)
    end
  end

  describe '#parent_stories_collection' do
    before do
      Story.stub(
        without_parents: [ :a, :b ]
      )

      controller.stub(:flattened_child_stories_collection).with(story, :a).and_return(['a'])
      controller.stub(:flattened_child_stories_collection).with(story, :b).and_return(['b'])
    end

    def parent_stories_collection
      controller.send(:parent_stories_collection, story)
    end

    specify do
      parent_stories_collection.should == [ 'a', 'b' ]
    end

    specify do
      parent_stories_collection

      controller.should have_received(:flattened_child_stories_collection).with(story, :a)
    end

    specify do
      parent_stories_collection

      controller.should have_received(:flattened_child_stories_collection).with(story, :b)
    end
  end

  describe '#flattened_child_stories_collection' do
    let(:parent_story) do
      create :story,
        id: 1,
        title: "Story 1"
    end

    def create_child_story
      story = create :story,
        id: 2,
        title: "Story 2"

      parent_story.child_stories << story

      story
    end

    context 'when the story is neither parent nor child story' do
      before { create_child_story }

      specify do
        controller.send(:flattened_child_stories_collection, story, parent_story).should == [
          [ '#1: Story 1', 1 ],
          [ '#1/#2: Story 2', 2 ]
        ]
      end
    end

    context 'when the story is the parent story' do
      specify do
        controller.send(:flattened_child_stories_collection, story, story).should == []
      end
    end

    context 'when the story is the child of a child story' do
      before do
        child_story = create_child_story

        child_story.child_stories << story
      end

      specify do
        controller.send(:flattened_child_stories_collection, story, parent_story).should == [
          [ '#1: Story 1', 1 ]
        ]
      end
    end
  end
end
