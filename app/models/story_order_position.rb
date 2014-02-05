class StoryOrderPosition < ActiveRecord::Base
  belongs_to :story
  belongs_to :story_order
  acts_as_list scope: :story_order
end
