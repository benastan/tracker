class StoriesController < ApplicationController
  respond_to :json, :html

  before_filter do
    @unblocked_unstarted_stories = Story.unblocked.unstarted.order('min_epic_parent_story_epic_order ASC')
    @unblocked_unstarted_stories_for_sidebar = @unblocked_unstarted_stories.order('title ASC').first(5)
    calculation = @unblocked_unstarted_stories.count - 5
    @unblocked_unstarted_stories_more_count_for_sidebar = calculation if calculation > 0
    @epic_stories = Story.epic_ordered
    @started_stories = Story.strict_started
  end

  after_filter only: :update do
    if @epic_order_changed
      UpdateStoriesMinEpicParentStoryEpicOrder.perform
    end
  end

  def index
  end

  def new
    @story = Story.new
  end

  def create
    permitted_params = params.require(:story).permit(:title)
    story = Story.create(permitted_params)
    redirect_to story
  end

  def show
    @story = Story.find(params[:id])
    @parent_story_stories = @story.parent_story_stories
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

  def update
    story = Story.find(params[:id])
    story_attributes = params.require(:story).permit(*permitted_update_parameters)
    story.update_attributes!(story_attributes)
    @epic_order_changed = story.previous_changes.key?(:epic_order)
    redirect_to(@epic_order_changed ? :root :  story)
  end

  def destroy
    story = Story.find(params[:id])
    story.destroy!
    redirect_to :root
  end

  protected

  def permitted_update_parameters
    [
      :title,
      :started_at,
      :finished_at,
      :closed_at,
      :epic_order_position,
      :focus,
      { parent_story_stories_attributes: [ :parent_story_id ] }
    ]
  end
end
