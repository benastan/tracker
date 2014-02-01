require 'spec_helper'

describe StoryStory do
	it { should belong_to(:parent_story).class_name(:Story) }
	it { should belong_to(:child_story).class_name(:Story) }
end
