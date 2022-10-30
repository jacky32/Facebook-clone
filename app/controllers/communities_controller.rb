class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @community_posts = current_user.community_posts
  end
end
