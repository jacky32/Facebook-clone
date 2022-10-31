class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @community_posts = current_user.community_posts
  end

  def show
    community
  end

  private

  def community
    @community = Community.find(params[:id])
  end
end
