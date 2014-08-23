class MakeEpicStoriesFocusedMigration < ActiveRecord::Migration
  def change
    MakeEpicStoriesFocused.perform
  end
end
