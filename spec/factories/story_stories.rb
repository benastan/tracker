# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story_story do
    association :parent_story, factory: :story
    association :child_story, factory: :story
  end
end
