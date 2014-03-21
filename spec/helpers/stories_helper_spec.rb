require 'spec_helper'

describe StoriesHelper do
  describe 'render_sidebar' do
    specify do
      assign :epic_stories, []

      assign :unblocked_stories, []
      
      expect(helper.render_sidebar).to render_template 'shared/stories/_sidebar'
    end
  end
end