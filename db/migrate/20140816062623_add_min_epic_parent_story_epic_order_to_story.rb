class AddMinEpicParentStoryEpicOrderToStory < ActiveRecord::Migration
  def change
    add_column :stories, :min_epic_parent_story_epic_order, :integer
  end
end
