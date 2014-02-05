require 'spec_helper'

describe StoryOrderPosition do
  it { should belong_to(:story) }
  it { should belong_to(:story_order) }

  describe 'acts_as_list integration' do
    let(:story_order) { StoryOrder.create }

    before do
      3.times do
        story = create :story
        story_order.stories << story
      end
    end

    it 'implements acts_as_list' do
      first_position = story_order.story_order_positions.first

      first_position.move_to_bottom
      
      story_order.reload.story_order_positions.last.should == first_position
    end
  end
end
