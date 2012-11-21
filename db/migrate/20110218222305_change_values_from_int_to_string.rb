class ChangeValuesFromIntToString < ActiveRecord::Migration
  def self.up
    add_column :boulders, :relax_number_2, :string
    Boulder.all.each do |boulder|
      boulder.relax_number_2 = boulder.relax_number
      boulder.save
    end
  end

  def self.down
    remove_column :boulders, :relax_number_2
  end
end
