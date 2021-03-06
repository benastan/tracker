require 'spec_helper'

describe StoriesController do
  it { should route(:get, '/stories/new').to(action: :new) }
  it { should route(:post, '/stories').to(action: :create) }
  it { should route(:get, '/stories/1').to(action: :show, id: '1') }
  it { should route(:patch, '/stories/1').to(action: :update, id: '1') }
  it { should route(:delete, '/stories/1').to(action: :destroy, id: '1') }

  describe '#index' do
    let(:unblocked_unstarted_epic_ordered) do
      double(first: :'unblocked, unstarted, epic ordered first five', count: 9)
    end

    let(:unblocked_unstarted_ordered_by_title) do
      double(order: unblocked_unstarted_epic_ordered)
    end

    let(:unblocked_unstarted_stories) do
      double(order: unblocked_unstarted_ordered_by_title)
    end

    before do
      # Story.stub(
      #   unblocked: double('unblocked', unstarted: unblocked_unstarted_stories),
      #   epic_ordered: :epic_ordered,
      #   strict_started: :started,
      #   strict_finished: :finished,
      #   closed: :closed
      # )
    end

    describe 'before filter', simple_story_tree: true do
      let!(:focus_story) { create :story, :focus }

      before do
        middle_story.update(started_at: Time.new - 1.day)
        get(:index)
      end

      specify { assigns[:unblocked_unstarted_stories].should match_array [standalone_story, unblocked_story, focus_story] }
      specify { assigns[:unblocked_unstarted_stories_for_sidebar].should match_array [standalone_story, unblocked_story, focus_story] }
      specify { assigns[:unblocked_unstarted_stories_more_count_for_sidebar].should == nil }
      specify { assigns[:epic_stories].should == [focus_story] }
      specify { assigns[:started_stories].should == [middle_story] }
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
        parent_story_stories: 'kiddo',
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

        assigns(:parent_story_stories).should == 'kiddo'
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
  end

  describe 'PATCH #update' do
    let(:story) do
      build :story
    end

    before do
      story.stub(
        update_attributes!: true,
        id: 1
      )

      Story.stub(find: story)
    end

    specify do
      story_attributes = {
        title: 'some title',
        started_at: 'right now',
        finished_at: 'left now',
        closed_at: 'down now',
        epic_order_position: :first,
        focus: '1',
        parent_story_stories_attributes: [
          {
            parent_story_id: '12'
          }
        ]
      }

      patch(:update, id: 1, story: story_attributes)

      story.should have_received(:update_attributes!).with(
        'title' => 'some title',
        'started_at' => 'right now',
        'finished_at' => 'left now',
        'closed_at' => 'down now',
        'epic_order_position' => 'first',
        'focus' => '1',
        'parent_story_stories_attributes' => [
          {
            'parent_story_id' => '12'
          }
        ]
      )
    end

    context 'when epic_order_position changed' do
      before do
        allow(UpdateStoriesMinEpicParentStoryEpicOrder).to receive(:perform).and_return(nil)
        story.stub(previous_changes: { epic_order: '1' })
        patch(:update, id: 1, story: { epic_order_position: :first })
      end

      specify { expect(response).to redirect_to root_path }
      specify { expect(UpdateStoriesMinEpicParentStoryEpicOrder).to have_received(:perform) }
    end

    context 'when epic_order_position did not change' do
      before do
        allow(UpdateStoriesMinEpicParentStoryEpicOrder).to receive(:perform).and_return(nil)
        story.stub(previous_changes: {})
        patch(:update, id: 1, story: { title: 'some title' })
      end
      specify { expect(response).to redirect_to story }
      specify { expect(UpdateStoriesMinEpicParentStoryEpicOrder).not_to have_received(:perform) }
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
