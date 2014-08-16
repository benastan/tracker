require 'spec_helper'

describe 'stories/index.html.haml' do
  let(:unblocked_unstarted_story) { FactoryGirl.build(:story, id: 1, title: 'Some Unblocked Story') }

  let(:epic_story) { FactoryGirl.build(:story, id: 2, title: 'Some Blocked Story') }

  before do
    assign :unblocked_unstarted_stories, [ unblocked_unstarted_story ]

    assign :epic_stories, [ epic_story ]
  end

  specify do
    render.should have_css '#stories_index h3', text: 'Inbox'
  end

  specify do
    render.should have_css '#stories_index .story h5', text: 'Some Unblocked Story'
  end
end
