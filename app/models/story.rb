class Story < ActiveRecord::Base
  include RankedModel
  ranks :epic_order

  has_many :child_stories,
    through: :child_story_stories

  has_many :child_story_stories,
    foreign_key: :parent_story_id,
    class_name: :StoryStory,
    dependent: :destroy

  has_many :parent_stories,
    through: :parent_story_stories

	has_many :parent_story_stories,
    foreign_key: :child_story_id,
    class_name: :StoryStory,
    dependent: :destroy

  has_many :story_orders,
    through: :story_order_positions

  accepts_nested_attributes_for :parent_story_stories, allow_destroy: true

  after_save do
    if epic? && epic_order_changed?

      # extract_child_stories = -> (story) {
      #    story.child_stories.inject([ story ]) do |memo, child_story|
      #     memo.concat(extract_child_stories.call(child_story))
      #   end
      # }
      #
      # nested_child_stories = child_stories.inject([]) do |memo, child_story|
      #   memo.concat(extract_child_stories.call(child_story))
      # end

      # This is terrible!
      Story.all.each(&:update_min_epic_parent_story_epic_order)

    end
  end

  def self.epic_ordered
    epic.rank(:epic_order).all
  end

  def blocking?
    parent_stories.any?
  end

  def blocked?
    child_stories.any?
  end

  def update_min_epic_parent_story_epic_order
    update!(min_epic_parent_story_epic_order: calculate_min_epic_parent_story_epic_order)
  end

  def calculate_min_epic_parent_story_epic_order
    epic_parent_stories.pluck(:epic_order).min
  end

  def epic_parent_stories
    nested_parent_stories.epic
  end

  def nested_parent_stories
    Story.where("id in (#{parent_story_stories_sql})")
  end

  def parent_story_stories_sql
    <<-SQL
WITH RECURSIVE parent_stories(id, parent_story_id, child_story_id) AS (
  SELECT id, parent_story_id, child_story_id FROM story_stories WHERE child_story_id = #{id}
UNION ALL
  SELECT ss.id, ss.parent_story_id, ss.child_story_id
  FROM parent_stories ps, story_stories ss
  WHERE ps.parent_story_id = ss.child_story_id
) SELECT parent_story_id from parent_stories
SQL
  end

  def epic?
    blocked? && ! blocking?
  end

  def unblocked?
    ! blocked?
  end

  def serializable_hash(options = {})
    options[:methods] ||= []
    options[:methods] << :blocking?
    options[:methods] << :blocked?
    options[:methods] << :unblocked?
    options[:methods] << :epic?

    super(options)
  end

  class << self
    def unblocked
      where('(select count(id) from story_stories where story_stories.parent_story_id = stories.id) = 0')
    end

    def blocked
      where('(select count(id) from story_stories where story_stories.parent_story_id = stories.id) > 0')
    end

    def without_parents
      where('(select count(id) from story_stories where story_stories.child_story_id = stories.id) = 0')
    end

    def epic
      blocked.without_parents
    end

    def started
      where('started_at < (?)', Time.new)
    end

    def finished
      where('finished_at < (?)', Time.new)
    end

    def strict_started
      started.unfinished.unclosed
    end

    def strict_finished
      finished.unclosed
    end

    def closed
      where('closed_at < (?)', Time.new)
    end

    def unstarted
      where('started_at is NULL or started_at > (?)', Time.new)
    end

    def unfinished
      where('finished_at is NULL or finished_at > (?)', Time.new)
    end

    def unclosed
      where('closed_at is NULL or closed_at > (?)', Time.new)
    end
  end
end
