require 'spec_helper'

describe StoryOrder do
  it { should have_many(:story_order_positions).order(:position) }
  it { should have_many(:stories).through(:story_order_positions) }
end
