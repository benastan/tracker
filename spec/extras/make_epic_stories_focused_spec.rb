require 'spec_helper'

describe MakeEpicStoriesFocused do
  let!(:epic_story) { create :story, :epic }
  let!(:story) { create :story }

  subject { MakeEpicStoriesFocused.perform }

  it { should be_success }
  specify { expect(->{subject}).to change { epic_story.reload.focus }.from(false).to(true) }
end
