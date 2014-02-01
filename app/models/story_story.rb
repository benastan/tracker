class StoryStory < ActiveRecord::Base
	belongs_to :parent_story, class_name: :Story
	belongs_to :child_story, class_name: :Story
end
