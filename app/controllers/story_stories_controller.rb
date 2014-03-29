class StoryStoriesController < ApplicationController
  def create
    story_story = StoryStory.create(permitted_params[:story_story])

    redirect_to story_story.parent_story
  end

  def destroy
    story_story = StoryStory.find(params[:id])

    story_story.destroy

    redirect_to :root
  end

  protected

  def permitted_params
    params.permit(story_story: [
      :parent_story_id,
      :child_story_id,
      { child_story_attributes: :title }
    ])
  end
end
