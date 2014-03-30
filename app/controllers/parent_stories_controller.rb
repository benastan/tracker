class ParentStoriesController < ApplicationController
  def edit
    story = Story.find(params[:story_id])

    @parent_stories = parent_stories_collection(story)

    @story = story
  end

  protected

  def parent_stories_collection(child_story)
    Story.without_parents.inject([]) do |memo, story|
      memo.concat(flattened_child_stories_collection(child_story, story))
    end
  end

  def flattened_child_stories_collection(child_story, story, path_to_story = nil)
    return [] if story.id == child_story.id || child_story.parent_stories.include?(story)

    path_to_story = [ path_to_story, "##{story.id}" ].select(&:present?).join('/')

    child_stories = story.child_stories.inject([]) do |memo, parent_story_child_story|
      memo.concat(flattened_child_stories_collection(child_story, parent_story_child_story, path_to_story))
    end

    child_stories.unshift([ "#{path_to_story}: #{story.title}", story.id ])

    child_stories
  end
end