class User < ActiveRecord::Base
  has_many :players
  has_many :comments
  
  validates_presence_of :name, message: "name can't be blank"
  validates_length_of :name, minimum: 2, too_short: "name should have at least 2 characters"
  validates_uniqueness_of :name, message: "user already exists"
  validates_format_of :name,  with: /\A([a-z]|[\.])+\Z/, on: :create, message: "name should be in lowecase without spaces"
  
  validates_presence_of :email, message: "email can't be blank"
  validates_length_of :email, minimum: 6, too_short: "email address too short"
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "email address is invalid"
  validates_uniqueness_of :email, message: "email already exists"
  
  validates_presence_of :password, message: "password can't be blank"
  validates_confirmation_of :password, message: "password should match confirmation"
  validates_length_of :password, minimum: 3, too_short: "password should have at least 3 characters"
  attr_accessor :password
  before_save :encrypt_password
  
  def self.authenticate(name, password)
    user = find_by_name(name)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
    
  def admin?
    self.id == 1
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
    self.players.order(:match_id).each do |p|
      v = []
      v << p.match.id
      v << p.score.to_f
      scores << v
    end
    scores
  end
end