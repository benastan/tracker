# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    title 'My Story'
    focus false

    ignore do
      parent_story nil
    end

    after :create do |story, evaluator|
      if evaluator.parent_story
        story.parent_stories << evaluator.parent_story
      end
    end

    trait :focus do
      focus true
    end

    trait :epic do

      ignore do
        middle_story { create :story }
        bottom_story { create :story }
      end

      after(:create) do |story, evaluator|
        middle_story = evaluator.middle_story
        bottom_story = evaluator.bottom_story
        create :story_story, parent_story: story, child_story: middle_story
        create :story_story, parent_story: middle_story, child_story: bottom_story
        story.reload
      end
    end
  end
end
