class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @posts = Post.all.order('created_at DESC').includes(:user, :comments).max(10)
  end
end
