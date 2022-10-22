class LikesController < ApplicationController
  before_action :decide_likeable

  def create
    @like = @likeable.likes.new(user_id: current_user.id)
    respond_to do |format|
      if @like.save
        format.turbo_stream do
          flash.now[:notice] = "#{@likeable.class.name} liked!"
          render 'likes/update_buttons'
        end
      else
        format.turbo_stream { flash.now[:alert] = "Like wasn't successful!" }
      end
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "#{@likeable.class.name} unliked!"
        render 'likes/update_buttons'
      end
    end
  end

  private

  def decide_likeable
    if params[:comment_id]
      @likeable = Comment.find_by_id(params[:comment_id])
    elsif params[:post_id]
      @likeable = Post.find_by_id(params[:post_id])
    end
  end
end
