class RemoveAndAddPowerNumberAsString < ActiveRecord::Migration
  def self.up
    remove_column :boulders, :power_number
    add_column :boulders, :power_number, :string
  end

  def self.down
    remove_column :boulders, :power_number
    add_column :boulders, :power_number, :integer
  end
end
