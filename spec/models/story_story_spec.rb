require 'spec_helper'

describe StoryStory do
  let(:parent_story) { create :story }

  let(:child_story) { create :story }

  let(:story_story) do
    StoryStory.create(
      parent_story_id: parent_story.id,
      child_story_id: child_story.id
    )
  end

  it { should belong_to(:parent_story).class_name(:Story) }

  it { should belong_to(:child_story).class_name(:Story) }

  context 'when child_story attributes are provided' do
    before do
      StoryStory.any_instance.stub(
        child_story: double('child_story', new_record?: true)
      )
    end

    it { should_not validate_presence_of(:child_story_id) }
  end

  context 'when child_story attributes are not provided' do
    it { should validate_presence_of(:child_story_id) }
  end

  it { should validate_presence_of(:parent_story_id) }

  it { should accept_nested_attributes_for(:child_story) }

  describe 'validations' do
    context 'when the parent_story is nested beneath the child_story' do
      before { child_story.child_stories << parent_story }

      specify { child_story.parent_stories.should_not include parent_story }

      specify { child_story.child_stories.should include parent_story }
    end
  end

  describe '#parent_story_stories_of' do
    let(:story) { create :story }

    let(:mid_story_1) { mid_story_1 = story.parent_stories.create(title: 'mid story 1') }

    let(:mid_story_2) { mid_story_2 = story.parent_stories.create(title: 'mid story 2') }

    let!(:top_story_1) { mid_story_1.parent_stories.create(title: 'top story 1') }

    let!(:top_story_2) { mid_story_2.parent_stories.create(title: 'top story 2') }

    let(:top_story_3) { mid_story_2.parent_stories.create(title: 'top story 3') }

    let!(:tippy_top_story) { top_story_3.parent_stories.create(title: 'tippy top story') }

    let(:parent_story_stories) { StoryStory.parent_story_stories_of(story) }

    specify { parent_story_stories.should include mid_story_1.child_story_stories.first }

    specify { parent_story_stories.should include mid_story_2.child_story_stories.first }

    specify { parent_story_stories.should include top_story_1.child_story_stories.first }

    specify { parent_story_stories.should include top_story_2.child_story_stories.first }

    specify { parent_story_stories.should include top_story_3.child_story_stories.first }

    specify { parent_story_stories.should include tippy_top_story.child_story_stories.first }
  end

  describe '#serializable_hash' do
    specify do
      story_story.serializable_hash['parent_story'].should == parent_story.serializable_hash
    end
  end

  describe 'scopes' do
    let(:started_child) do
      create :story,
        started_at: Time.new
    end

    let(:finished_child) do
      create :story,
        finished_at: Time.new
    end

    let!(:closed_child) do
      create :story,
        closed_at: Time.new
    end

    let!(:child_started_story_story) do
      create :story_story,
        child_story: started_child
    end

    let!(:child_finished_story_story) do
      create :story_story,
        child_story: finished_child
    end

    let!(:child_closed_story_story) do
      create :story_story,
        child_story: closed_child
    end

    describe '.child_started' do
      specify do
        StoryStory.child_started.should == [ child_started_story_story ]
      end
    end

    describe '.child_finished' do
      specify do
        StoryStory.child_finished.should == [ child_finished_story_story ]
      end
    end

    describe '.child_closed' do
      specify do
        StoryStory.child_closed.should == [ child_closed_story_story ]
      end
    end

    describe '.child_unstarted' do
      specify do
        StoryStory.child_unstarted.should == [ child_finished_story_story, child_closed_story_story ]
      end
    end

    describe '.child_unfinished' do
      specify do
        StoryStory.child_unfinished.should == [ child_started_story_story, child_closed_story_story ]
      end
    end

    describe '.child_unclosed' do
      specify do
        StoryStory.child_unclosed.should == [ child_started_story_story, child_finished_story_story ]
      end
    end
  end
end
