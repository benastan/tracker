class AddClosedAtToStory < ActiveRecord::Migration
  def change
    add_column :stories, :closed_at, :datetime
  end
end
