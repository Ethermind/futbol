class Player < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  
  def self.add_to_match(player, user, match)
    if !Player.find_by_user_id_and_match_id(user.id, match.id)
      player.user = user
      player.match = match
      player.confirm = false
      player.cancel = false
      player.score = generate_score(player)
      player.save
    end
  end
  
  def self.do_confirm(player)
    set_player_confirmation(player, true)
  end
  
  def self.do_cancel(player)
    set_player_confirmation(player, false)
  end
  
  def self.do_penalize(player)
    player.score -=2
    player.save
  end
  
  private

  def self.generate_score(player)
    current_score = 0
    
    if player.id != nil
      last_player = Player.where("user_id = ? AND id < ?", player.user.id, player.id).last
    else
      last_player = Player.where("user_id = ?", player.user.id).last        
    end
    
    if last_player != nil
      current_score = last_player.score
    end

    current_score += 1.0 if player.confirm
    current_score -= 1.0 if player.cancel
    
    return current_score     
  end

  def self.set_player_confirmation(player, status)
    player.confirm = status
    player.cancel = !status
    player.score = generate_score(player)
    player.save
  end
end