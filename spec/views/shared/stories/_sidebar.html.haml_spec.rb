require 'spec_helper'

describe 'shared/stories/_sidebar.html.haml' do
  let(:started_at) { nil }

  let(:finished_at) { nil }

  let(:closed_at) { nil }

  let(:unblocked_unstarted_stories) do
    double 'unblocked unstarted stories collection',
      any?: false
  end

  let(:unblocked_unstarted_stories_for_sidebar) do
    double 'unblocked unstarted stories collection for sidebar',
      any?: false
  end

  let(:epic_stories) do
    double 'epic stories collection',
      any?: false
  end

  let(:started_stories) do
    double 'started stories collection',
      any?: false
  end

  before do
    assign :unblocked_unstarted_stories_for_sidebar, unblocked_unstarted_stories_for_sidebar
    assign :unblocked_unstarted_stories_more_count_for_sidebar, 9
    assign :unblocked_unstarted_stories, double(first: unblocked_unstarted_stories)

    assign :epic_stories, epic_stories

    assign :started_stories, started_stories
  end

  specify { render.should have_css '#stories_sidebar a', text: 'New Story' }

  specify { render.should have_link 'New Story', href: new_story_path }

  specify { render.should have_css '#stories_sidebar' }

  specify { render.should have_css '#stories_sidebar .sidebar_content' }

  describe 'stories list' do
    before do
      view.stub(render_sidebar_index: '')
    end

    context 'when there are not epic stories' do
      specify do
        render

        view.should_not have_received(:render_sidebar_index).with('Focuses', epic_stories)
      end
    end

    context 'when there are epic stories' do
      before { epic_stories.stub(any?: true) }

      specify do
        render

        view.should have_received(:render_sidebar_index).with('Focuses', epic_stories, epic: true)
      end
    end

    context 'when there are not unblocked, unstarted stories' do
      specify do
        render

        view.should_not have_received(:render_sidebar_index).with('Ready to Go', unblocked_unstarted_stories_for_sidebar, more: 9)
      end
    end

    context 'when there are unblocked, unstarted stories' do
      before { unblocked_unstarted_stories_for_sidebar.stub(any?: true) }

      specify do
        render

        view.should have_received(:render_sidebar_index).with('Ready to Go', unblocked_unstarted_stories_for_sidebar, more: 9)
      end
    end

    context 'when there are not started stories' do
      specify do
        render

        view.should_not have_received(:render_sidebar_index).with('In Progress', started_stories)
      end
    end

    context 'when there are started stories' do
      before { started_stories.stub(any?: true) }

      specify do
        render

        view.should have_received(:render_sidebar_index).with('In Progress', started_stories)
      end
    end
  end
end
