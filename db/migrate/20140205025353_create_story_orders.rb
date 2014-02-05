class CreateStoryOrders < ActiveRecord::Migration
  def change
    create_table :story_orders do |t|

      t.timestamps
    end
  end
end
