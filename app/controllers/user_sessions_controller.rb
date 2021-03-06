class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to account_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.try(:destroy)
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end

end