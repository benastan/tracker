class StoryStoriesController < ApplicationController
  respond_to :json

  def create
    story_story = StoryStory.create(permitted_params[:story_story])

    respond_with story_story
  end

  def new
    parent_story = Story.find(params[:story_id])

    @story_story = StoryStory.new(
      parent_story: parent_story
    )
  end

  protected

  def permitted_params
    params.permit(story_story: [ :parent_story_id, :child_story_id, { child_story_attributes: :title } ])
  end
end
