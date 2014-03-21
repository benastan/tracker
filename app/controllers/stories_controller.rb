class StoriesController < ApplicationController
  respond_to :json, :html

  before_filter do
    @unblocked_stories = story_order.stories.unblocked
    @epic_stories = story_order.stories.epic
  end

  def index
    respond_to do |format|
      format.html

      format.json do
        render json:
          if params[:unblocked]
            @unblocked_stories
          elsif params[:epic]
            @epic_stories
          else
            story_order.stories
          end
      end
    end
  end

  def new
    @story = Story.new
  end

  def create
    Story.create(permitted_params[:story])

    redirect_to :root
  end

  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html do
        @parent_stories = @story.parent_stories
        
        @child_stories = @story.child_stories
      end

      format.json do
        render json: @story.serializable_hash(includes: [ :child_stories, :parent_stories ])
      end
    end
  end  

  protected

  def permitted_params
    params.permit(story: [ :title ])
  end

  def story_order
    StoryOrder.first_or_create
  end
  helper_method :story_order
end
