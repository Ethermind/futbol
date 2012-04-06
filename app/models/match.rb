class Match < ActiveRecord::Base
  has_many :players
  has_many :comments
    
  validates_presence_of :name, :on => :create, :message => "name can't be blank"
end
