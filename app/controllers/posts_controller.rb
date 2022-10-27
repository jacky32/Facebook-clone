class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :post, only: %i[update destroy]

  def create
    @added = true
    @post = Post.new(post_params.merge(user: current_user))
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path, notice: 'Post created! ' }
        format.turbo_stream { flash.now[:notice] = 'Post created!' }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Post was not created' }
        format.turbo_stream { flash.now[:alert] = 'Post was not created' } # returns status OK
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_path, notice: 'Post edited!' }
        format.turbo_stream { flash.now[:notice] = 'Post edited!' }
      else
        format.html { redirect_to root_path, status: :unprocessable_entity, alert: 'Post was not edited!' }
        format.turbo_stream { flash.now[:alert] = 'Post was not edited!' }
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
    # flash.now[:notice] = "Post deleted!"
    # render turbo_stream: 'posts/destroy'
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:text)
  end
end
