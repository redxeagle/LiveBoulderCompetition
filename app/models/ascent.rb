class Ascent < ActiveRecord::Base
   belongs_to :participant
  belongs_to :boulder

   validates_uniqueness_of :participant_id, :scope => :boulder_id, :if => :new_record?

  scope :power, where(:state => ['top', 'flash'], :power => true)
  scope :relax, where(:state => ['top', 'flash'], :power => false)
end
