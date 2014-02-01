require 'spec_helper'

describe Story do
	it { should have_many(:parent_story_stories).class_name(:StoryStory).with_foreign_key(:child_story_id).dependent(:destroy) }
	it { should have_many(:child_story_stories).class_name(:StoryStory).with_foreign_key(:parent_story_id).dependent(:destroy) }
	it { should have_many(:parent_stories).through(:parent_story_stories) }
	it { should have_many(:child_stories).through(:child_story_stories) }

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
end
