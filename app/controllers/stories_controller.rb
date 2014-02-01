class StoriesController < ApplicationController
  def index
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def create
    Story.create(permitted_params[:story])
    redirect_to :root
  end

  def permitted_params
    params.permit(story: [ :title ])
  end
end
