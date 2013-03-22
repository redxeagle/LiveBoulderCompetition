class Participant < ActiveRecord::Base

  has_many :ascents, :dependent => :destroy
  has_many :boulders, :through => :ascents

  validates_numericality_of :age, :only_integer => true, :message => "Alter sollte ne Zahl sein"

  scope :power, where(:power => true)
  scope :relax, where(:power => false)
  scope :student, where(:student => true, :power => true)
  scope :leipziger, where(:location => "Leipzig", :power => true)
  scope :berliner, where(:location => "Berlin", :power => true)
  scope :u_achtzehn, where(["age < 18 AND age > 12 "]).where(:power => true)
  scope :u_achtzehn_men, where(["age < 18 AND age > 12 "]).where(:power => true, :gender => "männlich")
  scope :u_achtzehn_women, where(["age < 18 AND age > 12 "]).where(:power => true, :gender => 'weiblich')
  scope :senior, where(["age > 39 "]).where(:power => true)
  scope :senior_men, where(["age > 39 "]).where(:power => true, :gender => 'männlich')
  scope :senior_women, where(["age > 39 "]).where(:power => true, :gender => 'weiblich')
  scope :city, where(:location => Setting.all.first.ranking_city)
  scope :city_men, where(:location => Setting.all.first.ranking_city, :power => true, :gender => 'männlich')
  scope :city_women, where(:location => Setting.all.first.ranking_city, :power => true, :gender => 'weiblich')
  scope :woman_relax, where(:power => false, :gender => 'weiblich')
  scope :men_relax, where(:power => false, :gender => 'männlich')
  scope :woman_power, where(:power => true, :gender => 'weiblich')
  scope :men_power, where(:power => true, :gender => 'männlich')
  scope :kidsA, where(["age < 18 AND age > 15 "]).where(:power => false) # 16 -17
  scope :kidsB, where(["age < 16 AND age > 13 "]).where(:power => false) # 14 -15
  scope :kidsC, where(["age < 14 AND age > 11"]).where(:power => false) # 12 - 13
  scope :kidsE, where(["age < 12"]).where(:power => false) # 0 - 12
  scope :kidsE_men, where(["age < 12"]).where(:power => false, :gender => "männlich") # 0 - 12
  scope :kidsE_women, where(["age < 12"]).where(:power => false, :gender => "weiblich") # 0 - 12

  before_destroy :validation_for_names

  def validation_for_names
    if self.name || self.given_name
      false
    end
  end

  def label
    if self.name && self.given_name
      if self.private
        "#{self.given_name} #{self.name[0,1]}."
      else
        "#{self.given_name} #{self.name}"
      end
    else
      self.uid
    end
  end

  def length
    Participant.all.count
  end

  def points
    all_ascents = self.ascents.all
    return count(all_ascents)
  end

  def count(ascents)
    points = 0
    if self.power
      boulders = Boulder.power
      assessment = "power"
    else
      boulders = Boulder.relax
      assessment = "relax"
    end
    boulder_hash = {}
    boulders.each do |boulder|
      boulder_hash[boulder.id] = boulder.send("#{assessment}_points")
    end

    ascents.each do |ascent|
      case ascent.state
        when "flash"
          points = points + (boulder_hash.fetch(ascent.boulder_id) * 1.3)
        when "top"
          points = points + boulder_hash.fetch(ascent.boulder_id)
        when "zone"
          points = points + (boulder_hash.fetch(ascent.boulder_id) * 0.3)
      end
    end
    return points.to_i
  end

  def count_ascents
    return self.ascents.select{|a| a.state == "flash" || a.state == "top"}.length
  end

  def points_of_first_ascents
    all_ascents= self.ascents.all
    all_points = 0
    assessment = self.power ? "power" : "relax"
    place_array = []
    all_ascents.each do |ascent|
      next if ascent.state == "nichts"
      place = 0
        place = Ascent.where(:boulder_id => ascent.boulder.id, :power => self.power, :state => ['flash', 'top']).where("updated_at < ?",ascent.updated_at).length
        place_array << place
        if place < 5
          point = ascent.boulder.send("#{assessment}_points")/10
          point = point / (2**place)
          all_points = all_points + point
        end
    end
    return all_points
  end


end
