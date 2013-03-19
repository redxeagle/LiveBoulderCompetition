# coding: utf-8

class Boulder < ActiveRecord::Base
  has_many :ascents
  has_many :participants, :through => :ascents

  scope :power, where(:color => Setting.all.first.power_colors.split(', '))
  scope :relax, where(:color => Setting.all.first.relax_colors.split(', '))
  scope :yellow, where(:color => 'gelb')
  scope :blue, where(:color => 'blau')
  scope :green, where(:color => 'grün')
  scope :lightgreen, where(:color => 'hell-grün')
  scope :orange, where(:color => 'orange')
  scope :white, where(:color => 'weiß')
  scope :darkgreen, where(:color => 'dunkel-grün')
  scope :meliert, where(:color => 'meliert')
  scope :red, where(:color => 'rot')
  scope :grey, where(:color => 'grau')
  scope :whiteyellow, where(:color => 'weiß und gelb')
  scope :blueorange, where(:color => 'blau und orange')


  def which_ascent(participant)
    if participant
      ascent = self.ascents.where(:participant_id => participant).first
      return ascent.nil? ? "nichts": ascent.state
    end
  end

  def update_points(power)
    all_ascents = power ? self.ascents.power : self.ascents.relax
    count = all_ascents.length
    if count > 0
      power ? self.power_points = 1000/count : self.relax_points = 1000/count
      self.save
    else
      power ? self.power_points = 1000 : self.relax_points = 1000
      self.save
    end
  end

 def count_power_ascents
    return self.ascents.power.length
 end

 def count_relax_ascents
    return self.ascents.relax.length
 end

end
