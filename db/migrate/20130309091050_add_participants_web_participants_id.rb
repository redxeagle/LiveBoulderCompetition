class AddParticipantsWebParticipantsId < ActiveRecord::Migration
  def up
    add_column :participants, :web_participants_id, :integer
  end

  def down
    remove_column :participants, :web_participants_id
  end
end
