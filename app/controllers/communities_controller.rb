class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @community_posts = current_user.community_posts
  end

  def show
    community
    members_count
  end

  private

  def community
    @community ||= Community.find(params[:id])
  end

  def members_count
    @members_count ||= @community.members.count
  end
end
