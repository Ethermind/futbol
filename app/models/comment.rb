class Comment < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  validates_presence_of :message, message: "message can't be blank"
  validates_length_of :message, :minimum => 2, too_short: "message should have at least 2 characters"
  validates_presence_of :user, :on => :create, :message => "your session has been expired"
  validates_presence_of :match, :on => :create, :message => "your session has been expired"
end