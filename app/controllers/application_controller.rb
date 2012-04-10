class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl  
  before_filter :require_login
  before_filter :prepare_session

  def require_login
    redirect_to root_url if !get_current_user  
  end
  
  def require_admin
    redirect_to root_url if !get_current_user || !get_current_user.admin?  
  end
  
  def prepare_session
     if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
        reset_session
     end

     session[:expiry_time] = 15.minutes.from_now
  end

  def get_current_user
    User.find_by_id(session[:current_user])
  end
  
  def set_current_user(current_user)
    session[:current_user] = current_user.id
  end
  
end