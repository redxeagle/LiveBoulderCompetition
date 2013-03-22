class SettingsController < ApplicationController
  def show
    @setting = Setting.any? ? Setting.all.first : nil
  end
  def new
    @setting = Setting.new
  end
  def edit
    @setting = Setting.all.first
  end

  def new_participant
    @participant = Participant.all
    if params[:participant]
      last_id = Participant.last.uid + 15
      for i in 0..params[:participant][:length].to_i
        participant = Participant.new
        participant.uid = last_id
        participant.age = 1
        participant.save!
        last_id +=15
      end
    end
  end

  def update
    @setting= Setting.all.first
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Einstellungen updated!"
      redirect_to root_path
    else
      render :action => :edit
    end
  end
  def create
    @setting = Setting.new(params[:setting])
        if @setting.save
          flash[:notice] = "Einstellungen gespeichert!"
          redirect_to root_path
        else
          render :action => :new
        end
  end

end
