class ParticipantsController < ApplicationController


  def index
    @participants = Participant.all.sort_by{|p| p.uid}
  end

  def edit
    @participant = Participant.find(params[:id])
  end


  def update
    @participant = Participant.find(params[:id])
    if @participant.update_attributes(params[:participant])
      redirect_to :participants
    else
      redirect_to edit_participant_path(@participant)
    end

  end

  def show

  end

  def insert
    if params[:participant]
      @participant = Participant.find_by_uid(params[:participant][:uid], :include => [:ascents])
    end
    if @participant
      @boulders = @participant.power ? Boulder.power : Boulder.relax
    end

    if params[:boulders]
      @inserted = true
      update_or_create_ascent
    end

     respond_to do |format|
      format.mobile
      format.html
      format.js
      format.mobilejs
    end
  end


private

  def update_or_create_ascent

    params[:boulders].each do |boulder_id, ascent|
      boulder = Boulder.find_by_id(boulder_id)
      unless boulder.participants.exists?(@participant)
        new_ascent = Ascent.new
        new_ascent.participant = @participant
        new_ascent.power = @participant.power
        new_ascent.boulder = boulder
        new_ascent.state = ascent
        new_ascent.save
        boulder.update_points(@participant.power)
      else
        old_ascent = Ascent.find_by_boulder_id_and_participant_id(boulder.id, @participant.id)
        old_ascent.update_attribute(:state, ascent)
        boulder.update_points(@participant.power)
      end
    end

  end

end
