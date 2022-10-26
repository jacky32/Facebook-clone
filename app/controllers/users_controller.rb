class UsersController < ApplicationController
  def show
    user
    friends
    friends_count
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def friends
    @friends ||= user.friends
  end

  def friends_count
    @friends_count ||= friends.count
  end
end
