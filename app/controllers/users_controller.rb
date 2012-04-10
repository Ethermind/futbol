class UsersController < ApplicationController
  before_filter :require_admin
  skip_before_filter :require_login, :only => [:create, :login]
  skip_before_filter :require_admin, :only => [:create, :login, :update, :scores]
  
  def create
    user = User.new(params[:user])

    if user.save
      set_current_user(user)
    else
      flash[:error] = user.errors.first[1]
    end

    redirect_to root_url
  end
  
  def update
    user = User.find(params[:id])
    
    if !user.update_attributes(params[:user])
      flash[:error] = user.errors.first[1]
    end
  
    redirect_to root_url
  end
  
  def login
    user = User.new(params[:user])
    user = User.authenticate(user.name, user.password)
    
    set_current_user(user) if user
    flash[:error] = ("login fail") if !user

    redirect_to root_url
  end
  
  def list
    @users = User.all
    @user = get_current_user
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id) if @match
  end
  
  def scores
    @users = User.all
    @user = get_current_user
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id) if @match
  end
end