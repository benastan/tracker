class CreateStoryStories < ActiveRecord::Migration
  def change
    create_table :story_stories do |t|
      t.integer :parent_story_id
      t.integer :child_story_id

      t.timestamps
    end
  end
end
