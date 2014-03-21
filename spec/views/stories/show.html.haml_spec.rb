require 'spec_helper'

describe 'stories/show.html.haml' do
  let(:child_stories) { [] }

  let(:child_story) do
    create :story,
      title: "Child Story"
  end

  let(:story) do
    create :story,
      title: 'Story'
  end

  before do
    assign :child_stories, child_stories
    
    assign :story, story

    render
  end

  specify do
    rendered.should have_css '#show_story'
  end
  
  specify do
    rendered.should have_css 'h3', text: 'Story'
  end
  
  context 'when there are no child stories' do
    specify do
      rendered.should_not have_css 'h4', text: 'Sub-stories'
    end
  end

  context 'when there are child stories' do
    let(:child_stories) do
      [ child_story ]
    end

    specify do
      rendered.should have_css 'h4', text: 'Sub-stories'
    end

    specify do
      rendered.should have_css '.story', count: 2
    end

    specify do
      rendered.should have_css '.story h5', count: 1, text: 'Child Story'
    end      
  end
end
