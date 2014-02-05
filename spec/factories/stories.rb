# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    title 'My Story'

    ignore do
      parent_story nil
    end

    after :create do |story, evaluator|
      if evaluator.parent_story
        story.parent_stories << evaluator.parent_story
      end
    end
  end
end
