# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@user = User.create!(name: 'Test name1', email: 'a@a.cz', password: 'aaaaaa')
@user2 = User.create!(name: 'Test name2', email: 'b@a.cz', password: 'aaaaaa')
@user3 = User.create!(name: 'Test name3', email: 'c@a.cz', password: 'aaaaaa')
@user4 = User.create!(name: 'Test name4', email: 'd@a.cz', password: 'aaaaaa')

@user2.send_friend_request(@user)
@user3.send_friend_request(@user)
@user4.send_friend_request(@user)

@post = Post.create(user: @user, text: 'Text text text')
@comment = Comment.create(user: @user, commentable: @post, text: 'Comment text')
