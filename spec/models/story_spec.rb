require 'spec_helper'

describe Story do
  it { should have_many(:parent_story_stories).class_name(:StoryStory).with_foreign_key(:child_story_id).dependent(:destroy) }
  it { should have_many(:child_story_stories).class_name(:StoryStory).with_foreign_key(:parent_story_id).dependent(:destroy) }
  it { should have_many(:parent_stories).through(:parent_story_stories) }
  it { should have_many(:child_stories).through(:child_story_stories) }
  it { should have_many(:story_order_positions) }
  it { should have_many(:story_orders).through(:story_order_positions) }

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

  describe 'after_create' do
    let(:story) { create :story }

    shared_examples_for "it initialized the Story into a StoryOrder" do
      specify do
        story = create :story
        story.story_orders.should == [ StoryOrder.first ]
      end
    end

    context 'when there are no StoryOrder objects' do
      it_should_behave_like "it initialized the Story into a StoryOrder"

      it "creates a StoryOrder" do
        expect do
          create :story
        end.to change(StoryOrder, :count).by(1)
      end
    end

    context 'when there are StoryOrder objects' do
      before { StoryOrder.create }

      it_should_behave_like "it initialized the Story into a StoryOrder"

      it "does not create a StoryOrder" do
        expect do
          create :story
        end.not_to change(StoryOrder, :count)
      end
    end
  end

  describe '#serializable_hash' do
    let!(:parent_story) { Story.create }
    let!(:child_story) { parent_story.child_stories.create }

    it "includes the story's children" do
      parent_story.serializable_hash['child_stories'].should == [ child_story.serializable_hash ]
    end
  end

  describe 'factories' do
    let(:story) { create :story }
    specify { story.title.should be_a String }

    describe 'parent_story' do
      let(:child_story) { create :story, parent_story: story }

      specify { child_story.parent_stories.should == [ story ] }
    end
  end

  describe '.unblocked' do
    let(:epic_story) { create :story, title: 'Epic Story' }
    let(:middle_story) { create :story, title: 'Middle Story' }
    let(:unblocked_story) { create :story, title: 'Unblocked Story' }
    let!(:standalone_story) { create :story, title: 'Standalone Story' }

    before do
      epic_story.child_stories << middle_story
      middle_story.child_stories << unblocked_story
    end

    specify { Story.unblocked.should =~ [ unblocked_story, standalone_story ] }
  end

  describe '.epic' do
    let(:epic_story) { create :story, title: 'Epic Story' }
    let(:middle_story) { create :story, title: 'Middle Story' }
    let(:unblocked_story) { create :story, title: 'Unblocked Story' }
    let!(:standalone_story) { create :story, title: 'Standalone Story' }

    before do
      epic_story.child_stories << middle_story
      middle_story.child_stories << unblocked_story
    end

    specify { Story.epic.should =~ [ epic_story ] }
  end
end
