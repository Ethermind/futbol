# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

match = Match.create(name: "DEMO MATCH")
user = User.create(name: "admin", email: "luis.capra@gmail.com", password: "admin")
(1..9).each do |code|
  User.create(name: "testuser#{code}", email: "testuser#{code}@mail.com", password: "test")
end
comment = Comment.new(message: "Hello my friend", user: user, match: match)
match.comments << comment
user.comments << comment
match.save

# extended example to show statistics
(1..20).each do |number|
  match = Match.create(name: "Match Nbr: #{number}")
  User.all.each do |user|
    if rand(3) != 2
      player = Player.new
      player.user = user
      player.match = match
      match.players << player
      user.players << player
      
      if rand(2) == 1
        player.confirm = true
      else
        player.cancel = true
      end
      
      if rand(3) == 2
        player.confirm = false
        player.cancel = false
      end
      
      player.score = user.score # that logic should be in Player class
      player.save
    end
  end
  match.closed = true
  match.save
end




