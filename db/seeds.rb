# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.all.each { |usr| usr.destroy! }
Post.all.each { |pst| pst.destroy! }
Friendship.all.each { |pst| pst.destroy! }
Community.all.each { |cmt| cmt.destroy! }

@user = User.create(first_name: 'Joe', last_name: 'Smith', email: 'a@a.cz', password: 'aaaaaa')

FIRST_NAMES = %w[Joe Richard Jack Rick Abe Homer Bob Kate Lisa Bart Mary John Michael Linda Susan Sarah Karen Nancy
                 Betty Margaret Carol Dorothy George Kevin Andrew Donald Paul Helen Anna Angela Amy Scott Justin Larry
                 Stephen].freeze
LAST_NAMES = %w[Smith Johnson Williams Brown Jones Miller Davis Garcia Rodriguez Wilsom O'Neill O'Ryan Byrne Murphy
                Taylor Wilson Thomas Roberts Li Roy Anderson Harris Lewis Baker Matthews Knight Hughes Wright Jenkins
                Green Bell Cox Armstrong Carter Ford].freeze
TEXTS = ['Luiz Inácio da Silva was born on 27 October 1945 (registered with a date of birth of 6 October 1945) in Caetés (then a district of Garanhuns), located 250 km (150 miles) from Recife, capital of Pernambuco, a state in the Northeast of Brazil.',
         'Originally a fishing village and market town, Shanghai grew in importance in the 19th century due to both domestic and foreign trade and its favorable port location. The city was one of five treaty ports forced to open to European trade after the First Opium War. The Shanghai International Settlement and the French Concession were subsequently established.',
         'What a game today!', 'Animals in space originally served to test the survivability of spaceflight, before human spaceflights were attempted', 'Alpout-Udzhar is a village in the Ujar Rayon of Azerbaijan.'].freeze

COMMENTS = ['Wow!', 'No way!', 'Insane!', 'Yes, I agree', 'lol', 'yes', 'Why?'].freeze

@community = @user.created_communities.create!(name: 'Kangaroos', is_private: true)

20.times do |_i|
  id = ('A'..'X').to_a.sample + ('A'..'X').to_a.sample + ('A'..'X').to_a.sample + ('A'..'X').to_a.sample
  u = User.create(first_name: FIRST_NAMES.sample, last_name: LAST_NAMES.sample, email: "#{id}@test.test",
                  password: 'aaaaaa')
  2.times do
    Post.create(user: u, text: TEXTS.sample)
    commentable = [Post.all.sample, Comment.all.sample].sample
    Comment.create(commentable:, user: u, text: COMMENTS.sample)
  end

  u.send_friend_request(user_id: @user.id)
  u.send_join_request(@community)
end

# (5..15).to_a.each do |i|
#   u = User.find(i)
#   (1..20).to_a.each do |j|
#     next if j == i || j == 1

#     fr = u.send_friend_request(user_id: j)
#     next if fr.nil?

#     fr.accepted = true if [false, true].sample
#     fr.save!
#     fr.reload
#   end
# end

User.find(3).created_communities.create!(name: 'Dogs')

@post = Post.create(user: @user, text: 'Sample post')
@comment = Comment.create(user: @user, commentable: @post, text: 'Sample comment')
