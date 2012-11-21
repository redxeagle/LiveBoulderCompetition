class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.integer :uid
      t.string :name
      t.string :given_name
      t.string :location
      t.string :gender
      t.string :difficult_boulder
      t.integer :age
      t.boolean :student
      t.boolean :power
      t.boolean :private
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
