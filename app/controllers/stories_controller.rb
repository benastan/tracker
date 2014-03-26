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
    story = Story.create(permitted_params[:story])

    redirect_to story
  end

  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html do
        @parent_stories = @story.parent_stories
        
        child_story_stories = @story.child_story_stories

        @unstarted_child_story_stories = child_story_stories.child_unstarted.child_unfinished.child_unclosed
        
        @started_child_story_stories = child_story_stories.child_started.child_unfinished.child_unclosed

        @finished_child_story_stories = child_story_stories.child_started.child_finished.child_unclosed

        @closed_child_story_stories = child_story_stories.child_started.child_finished.child_closed

        @story_story = StoryStory.new(
          parent_story: @story,
          child_story: Story.new
        )
      end

      format.json do
        render json: @story.serializable_hash(includes: [ :child_stories, :parent_stories ])
      end
    end
  end

  def update
    story = Story.find(params[:id])

    story_attributes = params.require(:story).permit(:title, :started_at, :finished_at, :closed_at)

    story.update_attributes(story_attributes)
    
    redirect_to story
  end

  def destroy
    story = Story.find(params[:id])

    story.destroy!

    redirect_to :root
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
