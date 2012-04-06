class Comment < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  validates_presence_of :message, :message => "message can't be blank"
  validates_length_of :message, :minimum => 2, :too_short => "message should have at least 2 characters"
end