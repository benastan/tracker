# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story_order_position do
    story_id 1
    story_order_id 1
    weight 1
  end
end
