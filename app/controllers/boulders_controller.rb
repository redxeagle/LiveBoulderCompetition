# coding: utf-8
class BouldersController < ApplicationController

  def index
    @relax_boulders = Boulder.relax
    @power_boulders = Boulder.power
  end

  def show
    @boulder = Boulder.find_by_id(params[:id])
    if @boulder.nil?
      redirect_to boulders_path
    end
    @power_flashs = @boulder.ascents.where(:state => ['flash'], :power => true).length
    @power_tops = @boulder.ascents.where(:state => ['top'], :power => true).length
    @relax_flashs = @boulder.ascents.where(:state => ['flash'], :power => false).length
    @relax_tops = @boulder.ascents.where(:state => ['top'], :power => false).length
    starttime = Time.local(2010,11,02)
    @time_array = []
    @ascent_array = []

    #ToDo Anpassen!!!
    while starttime < (Time.now + 1.day)
      @time_array << ["#{starttime.day}."]
      @ascent_array <<  Ascent.where(:state => ["flash", "top"], :boulder_id => @boulder.id).where("updated_at < ?", starttime).length
      starttime = starttime + 1.day
    end

  end

  def ranking
    cache_duration = 120
    @cache_time = Rails.cache.fetch('time', :expires_in => cache_duration) { Time.now }
    @settings = Setting.all.first
    @participants_hash = {}
    ranking_tabs = @settings.ranking_tabs.split(',')

    @participants_hash[:all] = Rails.cache.fetch('participants', :expires_in => cache_duration) {
               Participant.all.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
    }

    @participants_hash[:relax] = Rails.cache.fetch('participants_relax', :expires_in => cache_duration) do
            Participant.relax.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
    end

    if(ranking_tabs.include?("men_relax"))
      @participants_hash[:relax_men] =  Rails.cache.fetch('participants_relax_men', :expires_in => cache_duration) do
                Participant.men_relax.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end

    if(ranking_tabs.include?("women_relax"))
      @participants_hash[:relax_women] =  Rails.cache.fetch('participants_relax_woman', :expires_in => cache_duration) do
            Participant.woman_relax.map{|e| [e.label, e.count_ascents, e.location,
                                         e.points]}.sort_by{|u| u[3]}.reverse
      end
    end

    if(@settings.power?)
      @participants_hash[:power] = Rails.cache.fetch('participants_power', :expires_in => cache_duration) do
                  Participant.power.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_hash[:power_men] = Rails.cache.fetch('participants_power_men', :expires_in => cache_duration) do
                  Participant.men_power.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_hash[:power_women] = Rails.cache.fetch('participants_power_women', :expires_in => cache_duration) do
                  Participant.woman_power.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end

    if(!@settings.ranking_city.empty? && ranking_tabs.include?("city"))
      @participants_hash[:city] = Rails.cache.fetch('participants_city', :expires_in => cache_duration) do
                        Participant.city.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(!@settings.ranking_city.empty? && ranking_tabs.include?("city_men"))
      @participants_hash[:city_men] = Rails.cache.fetch('participants_city', :expires_in => cache_duration) do
                        Participant.city_men.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(!@settings.ranking_city.empty? && ranking_tabs.include?("city_women"))
      @participants_hash[:city_women] = Rails.cache.fetch('participants_city', :expires_in => cache_duration) do
                        Participant.city_women.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("senior"))
      @participants_hash[:senior] = Rails.cache.fetch('participants_senior', :expires_in => cache_duration) do
        Participant.senior.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("senior_men"))
      @participants_hash[:senior_men] = Rails.cache.fetch('participants_senior', :expires_in => cache_duration) do
        Participant.senior_men.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("senior_women"))
      @participants_hash[:senior_women] = Rails.cache.fetch('participants_senior', :expires_in => cache_duration) do
        Participant.senior_women.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("kidsE"))
      @participants_hash[:kidsE] = Rails.cache.fetch('participants_kidsE', :expires_in => cache_duration) do
        Participant.kidsE.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("kidsE_women"))
      @participants_hash[:kidsE_women] = Rails.cache.fetch('participants_kidsE', :expires_in => cache_duration) do
        Participant.kidsE_men.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("kidsE_men"))
      @participants_hash[:kidsE_men] = Rails.cache.fetch('participants_kidsE', :expires_in => cache_duration) do
        Participant.kidsE_women.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("u_achtzehn"))
      @participants_hash[:u_achtzehn] = Rails.cache.fetch('participants_u_achtzehn', :expires_in => cache_duration) do
        Participant.u_achtzehn.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("u_achtzehn_women"))
      @participants_hash[:u_achtzehn_women] = Rails.cache.fetch('participants_u_achtzehn', :expires_in => cache_duration) do
        Participant.u_achtzehn_women.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
    if(ranking_tabs.include?("u_achtzehn_men"))
      @participants_hash[:u_achtzehn_men] = Rails.cache.fetch('participants_u_achtzehn', :expires_in => cache_duration) do
        Participant.u_achtzehn_men.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
    end
  end

  def mass_edit
    @boulders = Boulder.all.sort_by{|e| e.id}
    @colors = Setting.all.first.colors.split(", ")
    @colors.insert(0, "Bitte Farbe wählen")
  end

  def mass_update

    boulders = params[:boulders][:boulder_attributes]

    boulders.each do |key, value|
      boulder = Boulder.find_by_id(key)
      boulder.update_attributes(value)
    end

    count = params[:count]


    while count.to_i - 1 >= Boulder.all.count
      boulder = Boulder.new
      boulder.save
    end

    redirect_to root_path
  end

  def update

  end

  def show_participant

  end



  private

  def filter_relax(filter_hash)
    wertung = filter_hash[:Wertung]
    case wertung
      when "1"
        participants_relax = Participant.where(:power => false)
      when "2"
        participants_relax = Participant.where(:gender => "männlich", :power => false).where("age > ?", 12)
      when "3"
        participants_relax = Participant.where(:gender => "weiblich", :power => false).where("age > ?", 12)
      when "4"
        participants_relax = Participant.where("age < ?", 13).where(:power => false).where("age > 1")
      when "5"
        participants_relax = Participant.relax.where("age > 12").where("age < 18").where(:gender => "männlich")
      when "6"
        participants_relax = Participant.relax.where("age > 12").where("age < 18").where(:gender => "weiblich")
      else
    end
    return participants_relax ? participants_relax.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse : []
  end

  def filter_power(filter_hash)
    wertung = filter_hash[:Wertung]
    case wertung
      when "1"
        participants_power = Participant.where(:power => true)
      when "2"
        participants_power = Participant.where(:gender => "männlich", :power => true).where("age > ?", 12)
      when "3"
        participants_power = Participant.where(:gender => "weiblich", :power => true).where("age > ?", 12)
      when "4"
        participants_power = Participant.where("age < ?", 13).where(:power => true).where("age > 1")
      when "5"
        participants_power = Participant.power.where("age > 12").where("age < 18").where(:gender => "männlich")
      when "6"
        participants_power = Participant.power.where("age > 12").where("age < 18").where(:gender => "weiblich")
      else
    end
    return participants_power ? participants_power.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse : []
  end

  def filter(filter_hash)
    wertung = filter_hash[:Wertung]
    case wertung
      when "1"
        participants = Participant.all
      when "2"
        participants = Participant.where(:gender => "männlich").where("age > ?", 12)
      when "3"
        participants = Participant.where(:gender => "weiblich").where("age > ?", 12)
      when "4"
        participants = Participant.where("age < ?", 13).where("age > 1")
      when "5"
        participants = Participant.where("age > 12").where("age < 18").where(:gender => "männlich")
      when "6"
        participants = Participant.where("age > 12").where("age < 18").where(:gender => "weiblich")
      else
    end
    return participants ? participants.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse : []
  end

  def filter_berlin(filter_hash)
    wertung = filter_hash[:Wertung]
    case wertung
      when "1"
        participants_berlin = Participant.leipziger
      when "2"
        participants_berlin = Participant.where(:gender => "männlich", :location => "Leipzig", :power => true).where("age > ?", 12)
      when "3"
        participants_berlin = Participant.where(:gender => "weiblich", :location => "Leipzig", :power => true).where("age > ?", 12)
      when "4"
        participants_berlin = Participant.where("age < ?", 13).where(:location => "Leipzig")
      when "5"
        participants = Participant.where("age > 12").where("age < 18").where(:location => "Leipzig").where(:gender => "männlich")
      when "6"
        participants = Participant.where("age > 12").where("age < 18").where(:location => "Leipzig").where(:gender => "weiblich")
      else
    end
    return participants_berlin ? participants_berlin.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse : []
  end

  def cache_it(object)

  end

end
