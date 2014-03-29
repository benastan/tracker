require 'spec_helper'

describe 'shared/stories/sidebar/_index.html.haml' do
  let(:story) do
    stub_model Story,
      id: 9,
      title: 'A Spooky Story'
  end

  before do
    view.stub(
      headline: 'Blargle Marg',
      stories: [ story ]
    )
  end

  specify { render.should have_css 'h2', text: 'Blargle Marg' }

  specify { render.should have_css '#blargle_marg_stories_list' }

  specify { render.should have_css 'li.story#story_9' }

  specify { render.should have_link 'A Spooky Story', href: url_for(story) }

  describe 'status icon' do
    context 'when the story is not started' do
      specify { render.should_not have_css 'i.fa.fa-circle.yellow' }

      specify { render.should_not have_css 'i.fa.fa-circle.green' }
    end

    context 'when the story is started' do
      before { story.stub(started_at: Time.new) }

      specify { render.should_not have_css 'i.fa.fa-circle.yellow' }

      specify { render.should have_css 'i.fa.fa-circle.green' }
    end

    context 'when the story is finished' do
      before { story.stub(started_at: Time.new, finished_at: Time.new) }

      specify { render.should have_css 'i.fa.fa-circle.yellow' }

      specify { render.should_not have_css 'i.fa.fa-circle.green' }
    end

    context 'when the story is finished and closed' do
      before { story.stub(started_at: Time.new, finished_at: Time.new, closed_at: Time.new) }

      specify { render.should_not have_css 'i.fa.fa-circle.yellow' }
      
      specify { render.should_not have_css 'i.fa.fa-circle.green' }
    end
  end
end