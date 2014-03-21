require 'spec_helper'

describe 'stories/show.html.haml' do
  let(:story) do
    create :story, title: 'My Story'
  end

  before do
    assign :story, story
  end

  specify do
    render.should have_css '#show_story'
  end
  
  specify do
    render.should have_css 'h3', text: 'My Story'
  end

  specify do
    render.should have_link 'Tasks', href: '#child_stories'
  end

  specify do
    render.should have_link 'Parents', href: '#parent_stories'
  end

  specify do
    render.should have_xpath "//div[@id='child_stories']/a[@href='#{story_path(story, format: :json)}']", text: 'Refresh'
  end

  specify do
    render.should have_xpath "//div[@id='parent_stories']/a[@href='#{story_path(story, format: :json)}']", text: 'Refresh'
  end
  
  specify do
    render.should_not have_css "//div[@id='parent_stories']/div[@class='story']"
  end
  
  specify do
    render.should_not have_css "//div[@id='child_stories']/div[@class='story']"
  end

  describe '#child_stories' do
    context 'when the story has child stories' do
      let!(:child_story) do
        story.child_stories.create(attributes_for(:story, title: 'Child'))
      end
      
      specify do
        render.should have_css "//div[@id='child_stories']/div[@class='story']/h4", text: 'Child'
      end
      
      specify do
        render.should_not have_css "//div[@id='parent_stories']/div[@class='story']"
      end
    end
  end

  describe '#parent_stories' do
    context 'when the story has parent stories' do
      let!(:parent_story) do
        story.parent_stories.create(attributes_for(:story, title: 'Parent'))
      end
      
      specify do
        render.should have_css "//div[@id='parent_stories']/div[@class='story']/h4", text: 'Parent'
      end
      
      specify do
        render.should_not have_css "//div[@id='child_stories']/div[@class='story']"
      end
    end
  end
end