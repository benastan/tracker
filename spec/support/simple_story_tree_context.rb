shared_context 'simple story tree', simple_story_tree: true do
  let(:epic_story) { create :story, title: 'Epic Story' }
  let(:middle_story) { create :story, title: 'Middle Story' }
  let(:unblocked_story) { create :story, title: 'Unblocked Story' }
  let!(:standalone_story) { create :story, title: 'Standalone Story' }

  before do
    epic_story.child_stories << middle_story
    middle_story.child_stories << unblocked_story
  end
end
