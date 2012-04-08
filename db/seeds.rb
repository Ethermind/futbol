# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

user = User.create(name: "admin", email: "luis.capra@gmail.com", password: "admin")

if true #false
  (1..10).each do 
    match = Match.new(name: "DEMO MATCH")
    player = Player.new
    Player.add_to_match(player, user, match)
    match.save
  end
end

if true #false
  match = Match.create(name: "DEMO MATCH")

  (1..9).each do |code|
    User.create(name: "testuser#{code}", email: "testuser#{code}@mail.com", password: "test")
  end
  
  comment = Comment.new(message: "Hello my friend", user: user, match: match)
  match.comments << comment
  user.comments << comment
  match.save
end

if true #false
  # extended example to show statistics
  (1..20).each do |number|
    match = Match.create(name: "Match Nbr: #{number}", require_confirmation: true)
    User.all.each do |user|
      if rand(3) != 2
        player = Player.new
        Player.add_to_match(player, user, match)
        Player.do_confirm(player) if rand(2) == 1
        Player.do_cancel(player) if rand(3) == 2
      end
    end
  end

  match.save
  Match.close(match)
end