class RenameRelaxNumbers < ActiveRecord::Migration
  def self.up
    remove_column :boulders, :relax_number
    rename_column :boulders, :relax_number_2, :relax_number
  end

  def self.down
  end
end
