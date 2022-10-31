class CommunitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @community_posts = current_user.community_posts
  end

  # def create
  #   @added = true
  #   @post = Post.new(post_params.merge(user: current_user))
  #   respond_to do |format|
  #     if @post.save
  #       format.html { redirect_to post_path, notice: 'Post created! ' }
  #       format.turbo_stream { flash.now[:notice] = 'Post created!' }
  #     else
  #       format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Post was not created' }
  #       format.turbo_stream { flash.now[:alert] = 'Post was not created' } # returns status OK
  #     end
  #   end
  # end

  def show
    community
  end

  def update
    community
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to community_path(@community), notice: 'Community edited!' }
        format.turbo_stream { flash.now[:notice] = 'Community edited!' }
      else
        format.html do
          redirect_to community_path(@community), status: :unprocessable_entity, alert: 'Community was not edited!'
        end
        format.turbo_stream { flash.now[:alert] = 'Community was not edited!' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @post.destroy
        format.html { redirect_to root_path, notice: 'Post was deleted!' }
        format.turbo_stream { flash.now[:notice] = 'Post deleted!' }
      else
        format.html { redirect_to post_path(@post), status: :unprocessable_entity, alert: 'Post was not deleted!' }
        format.turbo_stream { flash.now[:alert] = 'Post was not deleted!' }
      end
    end
  end

  private

  def community
    @community ||= Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :info, :background, :is_private)
  end
end
