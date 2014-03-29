class ChildStoriesController < ApplicationController
  def new
    parent_story = Story.find(params[:story_id])

    @story_story = StoryStory.new(
      parent_story: parent_story,
      child_story: Story.new
    )
  end
end