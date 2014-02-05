class CreateStoryOrderPositions < ActiveRecord::Migration
  def change
    create_table :story_order_positions do |t|
      t.integer :story_id
      t.integer :story_order_id
      t.integer :position

      t.timestamps
    end
  end
end
