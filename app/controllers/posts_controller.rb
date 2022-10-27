class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.friends_posts
  end

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

  def edit
    post
  end

  def update
    post
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream { flash.now[:notice] = 'Post edited!' }
      else
        format.turbo_stream { flash.now[:alert] = 'Post was not edited!' }
      end
    end
  end

  def destroy
    post
    respond_to do |format|
      if @post.destroy
        format.turbo_stream { flash.now[:notice] = 'Post deleted!' }
      else
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
