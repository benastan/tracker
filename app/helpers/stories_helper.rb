module StoriesHelper
  def render_sidebar
    render 'shared/stories/sidebar'
  end

  def render_sidebar_index(headline, stories, options = {})
    render 'shared/stories/sidebar/index', options.merge(headline: headline, stories: stories)
  end
end
