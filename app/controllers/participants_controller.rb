class ParticipantsController < ApplicationController

  before_filter :require_user, :only => [:update, :clear, :show, :edit]
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

  def clear
    Participant.delete_all
    Ascent.delete_all
    redirect_to root_path
  end

  def upload
    if(params[:file_upload])
      file = params[:file_upload][:file]
      last_participant = Participant.last
      last_uid = last_participant.nil? ? 1001 : last_participant.uid
      Participant.transaction do
        FasterCSV.parse(file.tempfile).each do |row|
          last_uid += 15
          participant = Participant.new
          participant.uid = last_uid
          participant.web_participants_id = row[0]
          participant.name = row[1]
          participant.given_name = row[2]
          participant.location = row[3]
          participant.gender= row[4]
          participant.age= row[5]
          participant.power = row[6]
          participant.save
          if(participant.errors.any?)
            puts row[0] + row[1] + row[2] + row[3] + row[4] + row[5] + row[6]
            puts participant.errors.messages
          end
        end
      end
      redirect_to root_path
    end
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
