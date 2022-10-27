class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @posts = current_user.friends_posts
  end
end
