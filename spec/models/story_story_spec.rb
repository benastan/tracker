require 'spec_helper'

describe StoryStory do
  let(:parent_story) { create :story }
  let(:child_story) { create :story }
  let!(:story_story) { StoryStory.create(parent_story_id: parent_story.id, child_story_id: child_story.id) }

  it { should belong_to(:parent_story).class_name(:Story) }
  it { should belong_to(:child_story).class_name(:Story) }
  it { should validate_presence_of(:child_story_id) }
  it { should validate_presence_of(:parent_story_id) }

  describe 'validations' do
    shared_examples_for 'an invalid StoryStory' do
      it 'is not valid' do
        invalid_story_story = StoryStory.new(attributes)
        invalid_story_story.should_not be_valid
      end
    end

    context 'when a StoryStory exists with this parent_story_id and child_story_id' do
      let(:attributes) { { parent_story: parent_story, child_story: child_story } }
      it_should_behave_like 'an invalid StoryStory'
    end

    it 'cannot be its own parent' do
      invalid_story_story = parent_story.parent_story_stories.create(parent_story_id: parent_story.id)
      invalid_story_story.should_not be_valid
    end

    it 'cannot have a parent whose parent is itself' do
      parent_story.parent_story_stories.create(parent_story_id: child_story.id)
      invalid_story_story = child_story.parent_story_stories.create(parent_story_id: parent_story.id)
      invalid_story_story.should_not be_valid
    end
  end

  describe 'serializable_hash' do
    it 'includes #parent_story' do
      story_story.serializable_hash['parent_story'].should == parent_story.serializable_hash
    end
  end
end
