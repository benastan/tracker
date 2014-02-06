class StoryStory < ActiveRecord::Base
	belongs_to :parent_story, class_name: :Story
	belongs_to :child_story, class_name: :Story
  validates :parent_story_id, :child_story_id, presence: true
  validates :parent_story_id, uniqueness: { scope: :child_story_id }

  before_create do
    invalid_parent_story_stories = StoryStory.parent_story_stories_of(parent_story).where(parent_story: child_story)

    if invalid_parent_story_stories.any?
      invalid_parent_story_stories.destroy_all
    end

    true
  end

  def serializable_hash(options = {})
    options[:include] ||= []
    options[:include] << :parent_story
    super(options)
  end

  class << self
    def parent_story_stories_of(story)
      where("id in (#{parent_story_stories_sql_for(story.id)})")
    end

    def parent_story_stories_sql_for(story_id)
      <<-SQL
WITH RECURSIVE parent_stories(id, parent_story_id, child_story_id) AS (
    SELECT id, parent_story_id, child_story_id FROM story_stories WHERE child_story_id = #{story_id}
  UNION ALL
    SELECT ss.id, ss.parent_story_id, ss.child_story_id
    FROM parent_stories ps, story_stories ss
    WHERE ps.parent_story_id = ss.child_story_id
) SELECT id from parent_stories
SQL
    end
  end
end
