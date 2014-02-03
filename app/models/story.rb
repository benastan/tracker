class Story < ActiveRecord::Base
	has_many :parent_story_stories, foreign_key: :child_story_id, class_name: :StoryStory, dependent: :destroy
	has_many :child_story_stories, foreign_key: :parent_story_id, class_name: :StoryStory, dependent: :destroy
	has_many :parent_stories, through: :parent_story_stories
	has_many :child_stories, through: :child_story_stories

  def serializable_hash(options = {})
    options[:include] ||= []
    options[:include] << :child_stories
    super(options)
  end
end
