require 'spec_helper'

describe 'parent_stories/edit' do
  let(:story) do
    stub_model Story
  end

  let(:parent_story) do
    stub_model Story,
      id: 201
  end

  before do
    story.parent_story_stories.new

    assign :story, story

    assign :parent_stories, [ [ '#201', parent_story.id ] ]
  end

  specify do
    render.should have_css 'form.edit_story'
  end 

  specify do
    render.should have_css '#story_parent_story_stories_attributes_0_parent_story_id_201[type="radio"]'
  end

  specify do
    render.should have_css '#story_parent_story_stories_attributes_0_parent_story_id_201[value="201"]'
  end

  specify do
    render.should have_css '#story_parent_story_stories_attributes_0_parent_story_id_201[name="story[parent_story_stories_attributes][0][parent_story_id]"]'
  end

  specify do
    render.should have_css 'label[for="story_parent_story_stories_attributes_0_parent_story_id_201"]', text: '#201'
  end

  specify do
    render.should have_css 'input[type="submit"][value="Move Story"]'
  end
end