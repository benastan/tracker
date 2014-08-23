require 'spec_helper'

describe Story do
  it { should have_many(:parent_story_stories).class_name(:StoryStory).with_foreign_key(:child_story_id).dependent(:destroy) }
  it { should have_many(:child_story_stories).class_name(:StoryStory).with_foreign_key(:parent_story_id).dependent(:destroy) }
  it { should have_many(:parent_stories).through(:parent_story_stories) }
  it { should have_many(:child_stories).through(:child_story_stories) }
  it { should accept_nested_attributes_for(:parent_story_stories).allow_destroy(true) }

  describe 'parent child relation' do
    let!(:parent_story) { Story.create }
    let!(:child_story) { parent_story.child_stories.create }

    specify { parent_story.child_stories.count.should == 1 }
    specify { child_story.parent_stories.count.should == 1 }

    specify do
      parent_story.destroy
      child_story.parent_stories.count.should == 0
    end

    specify do
      child_story.destroy
      parent_story.child_stories.count.should == 0
    end
  end

  describe '#blocking?', simple_story_tree: true do
    specify { epic_story.should_not be_blocking }
    specify { middle_story.should be_blocking }
    specify { unblocked_story.should be_blocking }
    specify { standalone_story.should_not be_blocking }
  end

  describe '#blocked?', simple_story_tree: true do
    specify { epic_story.should be_blocked }
    specify { middle_story.should be_blocked }
    specify { unblocked_story.should_not be_blocked }
    specify { standalone_story.should_not be_blocked }
  end

  describe '#unblocked?', simple_story_tree: true do
    specify { epic_story.should_not be_unblocked }
    specify { middle_story.should_not be_unblocked }
    specify { unblocked_story.should be_unblocked }
    specify { standalone_story.should be_unblocked }
  end

  describe '#epic?', simple_story_tree: true do
    specify { epic_story.should be_epic }
    specify { middle_story.should_not be_epic }
    specify { unblocked_story.should_not be_epic }
    specify { standalone_story.should_not be_epic }
  end

  describe '#nested_parent_stories', simple_story_tree: true do
    specify { unblocked_story.nested_parent_stories.should == [ epic_story, middle_story ] }
    specify { middle_story.nested_parent_stories.should == [ epic_story ] }
  end

  describe '#epic_parent_stories', simple_story_tree: true do
    specify { unblocked_story.epic_parent_stories.should == [ epic_story ] }
    specify { middle_story.epic_parent_stories.should == [ epic_story ] }
  end

  describe '#serializable_hash', simple_story_tree: true do
    let(:serialized_hash) { epic_story.serializable_hash }

    specify { serialized_hash['blocking?'].should == false }
    specify { serialized_hash['blocked?'].should == true }
    specify { serialized_hash['unblocked?'].should == false }
    specify { serialized_hash['epic?'].should == true }
  end

  describe 'factories' do
    let(:story) { create :story }
    specify { story.title.should be_a String }

    describe 'parent_story' do
      let(:child_story) { create :story, parent_story: story }

      specify { child_story.parent_stories.should == [ story ] }
    end
  end

  describe '.unblocked', simple_story_tree: true do
    specify { Story.unblocked.should =~ [ unblocked_story, standalone_story ] }
  end

  describe '.epic', simple_story_tree: true do
    specify { Story.epic.should =~ [ epic_story ] }
  end

  describe '.epic_ordered', simple_story_tree: true do
    let!(:focus_story) { create :story, :focus }
    let!(:other_focus_story) { create :story, :focus }

    describe 'default order' do
      specify { Story.epic_ordered.should == [ focus_story, other_focus_story ] }
    end

    describe 're-ordered' do
      before { other_focus_story.update!(epic_order_position: :first) }
      specify { Story.epic_ordered.should == [ other_focus_story, focus_story ] }
    end
  end

  describe 'started, finished, closed scopes' do
    let!(:started_story) do
      create :story,
        started_at: Time.new - 1.hour
    end

    let!(:finished_story) do
      create :story,
        started_at: Time.new - 1.hour,
        finished_at: Time.new - 1.hour
    end

    let!(:closed_story) do
      create :story,
        started_at: Time.new - 1.hour,
        finished_at: Time.new - 1.hour,
        closed_at: Time.new - 1.hour
    end

    describe '.started' do
      specify do
        Story.started.should match_array [ started_story, finished_story, closed_story ]
      end
    end

    describe '.strict_started' do
      specify do
        Story.strict_started.should == [ started_story ]
      end
    end

    describe '.finished' do
      specify do
        Story.finished.should == [ finished_story, closed_story ]
      end
    end

    describe '.strict_finished' do
      specify do
        Story.strict_finished.should == [ finished_story ]
      end
    end

    describe '.closed' do
      specify do
        Story.closed.should == [ closed_story ]
      end
    end

    describe '.unstarted' do
      specify do
        Story.unstarted.should == []
      end
    end

    describe '.unfinished' do
      specify do
        Story.unfinished.should == [ started_story ]
      end
    end

    describe '.unclosed' do
      specify do
        Story.unclosed.should == [ started_story, finished_story ]
      end
    end
  end
end
