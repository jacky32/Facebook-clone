class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all.order('created_at DESC').includes(:user, :comments).max(10)
  end

  def create
    @post = Post.new(post_params.merge(user: current_user))
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path, notice: 'Post created! ' }
        format.turbo_stream { flash.now[:notice] = 'Post created!' }
      else
        format.html { render :new, status: :unprocessable_entity, alert: 'Post was not created' }
        format.turbo_stream { flash.now[:alert] = 'Post was not created' } # returns status OK
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:text)
  end
end
