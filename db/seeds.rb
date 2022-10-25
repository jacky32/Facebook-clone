# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@user1 = User.create!(first_name: 'Joe', last_name: 'Smith', email: 'a@a.cz', password: 'aaaaaa')
@user2 = User.create!(first_name: 'Abe', last_name: 'Grimson', email: 'b@a.cz', password: 'aaaaaa')
@user3 = User.create!(first_name: 'Bob', last_name: 'Adams', email: 'c@a.cz', password: 'aaaaaa')
@user4 = User.create!(first_name: 'Rick', last_name: 'Griffin', email: 'd@a.cz', password: 'aaaaaa')

@user2.send_friend_request(@user1)
@user3.send_friend_request(@user1)
@user4.send_friend_request(@user1)

@post = Post.create(user: @user1, text: 'Text text text')
@comment = Comment.create(user: @user1, commentable: @post, text: 'Comment text')
