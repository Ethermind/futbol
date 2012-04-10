class HomeController < ApplicationController
  skip_before_filter :require_login, only: [:index, :login, :signup, :about]
    
  def index
    @user = get_current_user
    @match = Match.last
    @player = @match.players.find_by_user_id(@user.id) if @user && @match
    @players = Player.find(:all, conditions: ["match_id = ?", @match.id], order: "confirm DESC, score DESC, created_at ASC") if @match
    @comment = Comment.new
    @show_actions_column = @match.require_confirmation && !@match.closed
  end
  
  def login
    @user = User.new
    @match = Match.last
  end
  
  def logout
    reset_session
    redirect_to root_url
  end
  
  def signup
    @user = User.new
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id) if @match
  end
  
  def about
    @user = get_current_user
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id) if @user && @match
  end

  def new_match
    @user = get_current_user
    @match = Match.new
    @player = @user.players.find_by_match_id(Match.last.id) if Match.last
  end
  
  def edit_match
    @user = get_current_user
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id)
    
    redirect_to root_url if @match.closed
  end

  def edit_user
    @user = User.find(params[:user])
    @match = Match.last
    @player = @user.players.find_by_match_id(Match.last.id) if @match
  end
  
  def add_user_to_match
    match = Match.last
    @user = get_current_user
    Player.add_to_match(Player.new, user, match)
    redirect_to root_url
  end
  
  def confirm_player_to_match
    Player.do_confirm(Player.find(params[:player]))
    redirect_to root_url
  end
  
  def cancel_player_to_match
    Player.do_cancel(Player.find(params[:player]))
    redirect_to root_url
  end

  def add_comment_to_match
    match = Match.last
    user = get_current_user
    comment = Comment.new(params[:comment])
    comment.match = match
    comment.user = user

    if !comment.save
      flash[:error] = comment.errors.first[1]
    end
    
    redirect_to root_url
  end
end