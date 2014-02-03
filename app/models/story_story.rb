class StoryStory < ActiveRecord::Base
	belongs_to :parent_story, class_name: :Story
	belongs_to :child_story, class_name: :Story
  validates :parent_story_id, :child_story_id, presence: true
  validates :parent_story_id, uniqueness: { scope: :child_story_id }
  
  validate do
    if parent_story_id == child_story_id
      errors.add(:parent_story_id, 'cannot be its own parent')
    end
  end

  def serializable_hash(options = {})
    options[:include] ||= []
    options[:include] << :parent_story
    super(options)
  end
end
