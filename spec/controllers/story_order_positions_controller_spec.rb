require 'spec_helper'

describe StoryOrderPositionsController do
  let(:story_order) { StoryOrder.create }
  let(:story_order_position) { story_order.story_order_positions.first }

  before do
    3.times do
      story = create :story
      story_order.stories << story
    end
  end

  it { should route(:patch, '/story_order_positions/1').to(action: :update, id: '1') }

  describe '#update' do
    def patch_update
      patch :update, id: story_order_position.id, story_order_position: { position: 2 }, format: :json
    end

    specify { patch_update.should be_success }

    specify do
      expect do
        patch_update
      end.to change { story_order_position.reload.position }.by(1)
    end
  end
end
