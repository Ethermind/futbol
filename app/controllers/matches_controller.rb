class MatchesController < ApplicationController
  before_filter :require_admin
  
  def new_match
    match = Match.new(params[:match])
  
    if !match.save
      SessionBag.set_error(flash, match.errors.first[1])
    end
  
    redirect_to root_url
  end

  def update
    match = Match.find(params[:id])
  
    if !match.update_attributes(params[:match])
      SessionBag.set_error(flash, match.errors.first[1])
    end
  
    if match.closed
      Match.close(match)
    end
  
    redirect_to root_url
  end
end