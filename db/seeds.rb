# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@user = User.create(first_name: 'Joe', last_name: 'Smith', email: 'a@a.cz', password: 'aaaaaa')

FIRST_NAMES = %w[Joe Richard Jack Rick Abe Homer Bob Kate Lisa Bart Mary John Michael Linda Susan Sarah Karen Nancy
                 Betty Margaret Carol Dorothy George Kevin Andrew Donald Paul Helen Anna Angela Amy Scott Justin Larry
                 Stephen].freeze
LAST_NAMES = %w[Smith Johnson Williams Brown Jones Miller Davis Garcia Rodriguez Wilsom O'Neill O'Ryan Byrne Murphy
                Taylor Wilson Thomas Roberts Li Roy Anderson Harris Lewis Baker Matthews Knight Hughes Wright Jenkins
                Green Bell Cox Armstrong Carter Ford].freeze

16.times do |i|
  u = User.create(first_name: FIRST_NAMES.sample, last_name: LAST_NAMES.sample, email: "t_#{i}@t.t", password: 'aaaaaa')
  p = Post.create(user: u, text: 'Post text text text text text text ')
  u.send_friend_request(@user)
end

@post = Post.create(user: @user1, text: 'Text text text')
@comment = Comment.create(user: @user1, commentable: @post, text: 'Comment text')
