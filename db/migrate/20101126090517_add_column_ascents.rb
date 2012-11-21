class AddColumnAscents < ActiveRecord::Migration
  def self.up
    add_column :ascents, :state, :string
  end

  def self.down
    remove_column :ascents, :state
  end
end
