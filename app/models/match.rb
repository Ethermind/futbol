class Match < ActiveRecord::Base
  has_many :players
  has_many :comments
  validates_presence_of :name, on: :create, message: "name can't be blank"
  
  def self.close(match)
    match.closed = true

    match.players.each do |p|
      Player.do_penalize(p) if !p.confirm && !p.cancel && match.require_confirmation
    end
    
    match.save
  end
  
end
