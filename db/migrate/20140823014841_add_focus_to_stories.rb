class AddFocusToStories < ActiveRecord::Migration
  def change
    add_column :stories, :focus, :boolean
  end
end
