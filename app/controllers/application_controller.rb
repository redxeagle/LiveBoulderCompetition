class ApplicationController < ActionController::Base
  protect_from_forgery
  #has_mobile_fu
  enable_mobile_fu
  before_filter :set_mobile_format
  before_filter :adjust_format_for_mobile


  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user


  def adjust_format_for_mobile
    if params[:mobile] == "true"
      session[:mobile_view] = true
    end

    if params[:mobile] == "false"
      session[:mobile_view] = false
    end

    if session[:mobile_view] == true
      request.format = :mobile
    end
  end

  def require_user
    unless current_user
    store_location
    flash[:notice] = "You must be logged in to access this page"
    redirect_to :new_user_session
    return false
    end
  end

  def require_no_user
    if current_user
    store_location
    flash[:notice] = "You must be logged out to access this page"
    redirect_to root_url
    return false
    end
  end

  private

    def redirect_back
      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        redirect_to session[:return_to]
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def store_location
    session[:return_to] = request.request_uri unless request.xhr?
    end

end
