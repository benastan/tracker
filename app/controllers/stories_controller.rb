class StoriesController < ApplicationController
  def index
    @stories = story_order.stories
  end

  def new
    @story = Story.new
  end

  def create
    Story.create(permitted_params[:story])
    redirect_to :root
  end

  protected

  def permitted_params
    params.permit(story: [ :title ])
  end

  def story_order
    StoryOrder.first_or_create
  end
end
