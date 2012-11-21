class CreateBoulders < ActiveRecord::Migration
  def self.up
    create_table :boulders do |t|
      t.string :color
      t.integer :relax_points,  :default => 1000
      t.integer :power_points,  :default => 1000
      t.integer :relax_number
      t.integer :power_number
      t.timestamps
    end
  end

  def self.down
    drop_table :boulders
  end
end
