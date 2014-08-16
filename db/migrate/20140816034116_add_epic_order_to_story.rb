class AddEpicOrderToStory < ActiveRecord::Migration
  def change
    add_column :stories, :epic_order, :integer
  end
end
