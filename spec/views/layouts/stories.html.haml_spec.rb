require 'spec_helper'

describe 'layouts/stories.html.haml' do
  before do
    view.stub(render_sidebar: '')

    render
  end

  describe 'sidebar' do
    specify do
      expect(view).to have_received(:render_sidebar)
    end
  end
end