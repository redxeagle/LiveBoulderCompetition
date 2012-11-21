class AddColumnAscentsPower < ActiveRecord::Migration
  def self.up
    add_column :ascents, :power, :boolean
  end

  def self.down
    remove_column :ascents, :power
  end
end
