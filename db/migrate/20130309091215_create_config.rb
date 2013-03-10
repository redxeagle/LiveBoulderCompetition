class CreateConfig < ActiveRecord::Migration
  def up
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

  def down
    drop_table :configs
  end
end
