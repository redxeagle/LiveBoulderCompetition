class RenameConfigurations < ActiveRecord::Migration
  def up
    rename_table :configurations, :settings
  end

  def down
    rename_table :settings, :configurations
  end
end
