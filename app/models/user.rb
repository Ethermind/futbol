class User < ActiveRecord::Base
  has_many :players
  has_many :comments
  validates_presence_of :name, message: "name can't be blank"
  validates_length_of :name, minimum: 2, too_short: "name should have at least 2 characters"
  validates_uniqueness_of :name, message: "user already exists"
  validates_presence_of :email, message: "email can't be blank"
  validates_length_of :email, minimum: 6, too_short: "email address too short"
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "email address is invalid"
  validates_uniqueness_of :email, message: "email already exists"
  validates_presence_of :password, message: "password can't be blank"
  validates_confirmation_of :password, message: "password should match confirmation"
  validates_length_of :password, minimum: 3, too_short: "password should have at least 3 characters"
  
  def admin?
    self.name == "admin"
  end

  def score
    if Player.find_by_user_id(self.id) != nil
      return Player.where("user_id = ?", self.id).last.score 
    else
      return 0
    end
  end
  
  def scores
    scores = []
    self.players.each do |p|
      v = []
      v << p.match.id
      v << p.score.to_f
      scores << v
    end
    scores
  end
end