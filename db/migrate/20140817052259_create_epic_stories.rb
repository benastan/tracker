class CreateEpicStories < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute(
      <<-SQL
CREATE VIEW epic_stories AS (
  SELECT * FROM stories WHERE
  (
    WITH RECURSIVE parent_stories(id, parent_story_id, child_story_id)
    AS (
      SELECT id, parent_story_id, child_story_id
      FROM story_stories
      WHERE child_story_id = stories.id
        UNION ALL
          SELECT ss1.id, ss1.parent_story_id, ss1.child_story_id
          FROM parent_stories ps, story_stories ss1
          WHERE ss1.child_story_id = ps.parent_story_id
    )
    SELECT COUNT(parent_story_id) FROM parent_stories
  ) = 0
)
SQL
    )
  end
end
