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
    unless params[:filter]
      @participants = Rails.cache.fetch('participants', :expires_in => cache_duration) {
         Participant.all.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      }
      @participants_relax  = Rails.cache.fetch('participants_relax', :expires_in => cache_duration) do
          Participant.relax.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_power  = Rails.cache.fetch('participants_power', :expires_in => cache_duration) do
        Participant.power.map{|e| [e.label, e.count_ascents, e.location, e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_leipzig  = Rails.cache.fetch('participants_leipzig', :expires_in => cache_duration) do
        Participant.leipziger.map{|e| [e.label, e.count_ascents, e.location,
                                     e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_kinder  = Rails.cache.fetch('participants_kinder', :expires_in => cache_duration) do
        Participant.kinder.map{|e| [e.label, e.count_ascents, e.location,
                                     e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_seniors  = Rails.cache.fetch('participants_senior', :expires_in => cache_duration) do
        Participant.senior.map{|e| [e.label, e.count_ascents, e.location,
                                     e.points]}.sort_by{|u| u[3]}.reverse
      end
      @participants_u_18  = Rails.cache.fetch('participants_u_18', :expires_in => cache_duration) do
        Participant.u_achtzehn.map{|e| [e.label, e.count_ascents, e.location,
                                     e.points]}.sort_by{|u| u[3]}.reverse
      end
    else
      @participants_relax = filter_relax(params[:filter])
      @participants_power = filter_power(params[:filter])
      @participants_leipzig = filter_berlin(params[:filter])
      @participants_kinder = filter(params[:filter])
      @participants_leipzig = filter_berlin(params[:filter])
      @participants_u_18 = Participant.u_achtzehn
    end
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
