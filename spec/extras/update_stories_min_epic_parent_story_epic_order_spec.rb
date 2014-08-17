require 'spec_helper'
require 'pathname'

describe UpdateStoriesMinEpicParentStoryEpicOrder do
  describe '.sql' do
    let(:sql_fixture_path) do
      Rails.root.join(*%w(
        spec
        support
        fixtures
        sql
        update_stories_min_epic_parent_story_epic_order.sql
      ))
    end

    let(:sql_fixture) { Pathname(sql_fixture_path).read }

    specify { expect(described_class.sql).to eq(sql_fixture) }
  end

  describe '.perform', simple_story_tree: true do
    let(:other_epic_story) { create :story }

    before do
      create :story_story, parent_story: other_epic_story, child_story: middle_story
      unblocked_story.update_column(:min_epic_parent_story_epic_order, -1_000_000)
      epic_story.update_column(:epic_order, -1_000_000)
      other_epic_story.update_column(:epic_order, -2_000_000)
    end

    specify do
      expect(->{described_class.perform})
        .to change { unblocked_story.reload.min_epic_parent_story_epic_order }
        .from(-1_000_000)
        .to(-2_000_000)
    end
  end
end
