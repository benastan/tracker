require 'spec_helper'

describe 'child_stories/new.html.haml' do
  let(:story_story) do
    StoryStory.new(
      parent_story_id: 'cologne',
      child_story: Story.new
    )
  end

  before do
    assign :story_story, story_story

    render
  end

  describe 'form' do
    specify do
      rendered.should have_css '#new_story_story'
    end

    specify do
      rendered.should have_css "#new_story_story[action='#{story_stories_path}']"
    end

    describe 'parent story id field' do
      specify do
        rendered.should have_css '#new_story_story #story_story_parent_story_id[type="hidden"]'
      end
      
      specify do
        rendered.should have_css '#new_story_story #story_story_parent_story_id[name="story_story[parent_story_id]"]'
      end
      
      specify do
        rendered.should have_css '#new_story_story #story_story_parent_story_id[value="cologne"]'
      end
    end

    describe 'child story title' do
      specify do
        rendered.should have_css '#new_story_story #story_story_child_story_attributes_title[type="text"]'
      end
      
      specify do
        rendered.should have_css '#new_story_story #story_story_child_story_attributes_title[name="story_story[child_story_attributes][title]"]'
      end
    end

    describe 'child story title' do
      specify do
        rendered.should have_css '#new_story_story #story_story_child_story_attributes_title[type="text"]'
      end
      
      specify do
        rendered.should have_css '#new_story_story #story_story_child_story_attributes_title[name="story_story[child_story_attributes][title]"]'
      end
    end

    describe 'submit button' do    
      specify do
        rendered.should have_css '#new_story_story input[type="submit"]'
      end

      specify do
        rendered.should have_css '#new_story_story input[value="Create Story"]'
      end
    end
  end
end