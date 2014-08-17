UPDATE stories SET min_epic_parent_story_epic_order = (
  SELECT min(epic_order) FROM epic_stories
  WHERE stories.id IN (
    WITH RECURSIVE child_stories(id, parent_story_id, child_story_id)
    AS (
      SELECT id, parent_story_id, child_story_id
      FROM story_stories
      WHERE parent_story_id = epic_stories.id
        UNION ALL
          SELECT ss2.id, ss2.parent_story_id, ss2.child_story_id
          FROM child_stories cs, story_stories ss2
          WHERE ss2.parent_story_id = cs.child_story_id
    )
    SELECT child_story_id FROM child_stories
  )
);
