require 'spec_helper'

describe StoriesHelper do
  describe 'render_sidebar' do
    specify do
      assign :epic_stories, []
      assign :unblocked_unstarted_stories, []
      assign :unblocked_unstarted_stories_for_sidebar, []
      assign :unblocked_unstarted_stories_for_sidebar, []
      assign :unblocked_unstarted_stories_more_count_for_sidebar, 0
      assign :started_stories, []

      expect(helper.render_sidebar).to render_template 'shared/stories/_sidebar'
    end
  end

  describe 'render_sidebar_index' do
    specify do
      expect(helper.render_sidebar_index('Headline', [])).to render_template 'shared/stories/sidebar/_index'
    end
  end
end
