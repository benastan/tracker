class StoryOrder < ActiveRecord::Base
  has_many :story_order_positions, order: :position
  has_many :stories, through: :story_order_positions
end
