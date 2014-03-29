module StoriesHelper
  def render_sidebar
    render 'shared/stories/sidebar'
  end

  def render_sidebar_index(headline, stories)
    render 'shared/stories/sidebar/index', headline: headline, stories: stories
  end
end
