class CreateConfigurations < ActiveRecord::Migration
  def up
    drop_table :configs
    create_table :configurations do |t|
      t.string :ranking_city
      t.string :ranking_tabs
      t.string :colors
      t.string :relax_colors
      t.string :power_colors
      t.boolean :power
      t.timestamps
    end
  end

  def down
    drop_table :settings
    create_table :configs do |t|
      t.string :ranking_city
      t.string :ranking_tabs
      t.string :colors
      t.string :relax_colors
      t.string :power_colors
      t.boolean :power
      t.timestamps
    end
  end
end
