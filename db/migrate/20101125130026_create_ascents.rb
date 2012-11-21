class CreateAscents < ActiveRecord::Migration
  def self.up
    create_table :ascents do |t|
      t.integer :boulder_id
      t.integer :participant_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ascents
  end
end
