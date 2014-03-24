class Story < ActiveRecord::Base

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

  has_many :story_order_positions

  after_create do
    story_order = StoryOrder.first_or_create
    story_order.stories << self
  end

  def blocking?
    parent_stories.any?
  end

  def blocked?
    child_stories.any?
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

    def epic
      where('(select count(id) from story_stories where story_stories.child_story_id = stories.id) = 0')
        .where('(select count(id) from story_stories where story_stories.parent_story_id = stories.id) > 0')
    end
  end
end

