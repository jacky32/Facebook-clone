class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :decide_commentable, only: %i[create new]

  def index
    @comments = Comments.all.order('created_at DESC').includes(:user, :comments)
  end

  def new
    @comment = Comment.new
    @post ||= Post.find(params[:post_id]) if params[:post_id]
  end

  def create
    @post = helpers.get_parent_post(@commentable)
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post), notice: 'Comment created! ' }
        format.turbo_stream { flash.now[:notice] = 'Comment created!' }
      else
        format.html { redirect_to post_path(@post), status: :unprocessable_entity, alert: 'Comment was not created!' }
        format.turbo_stream { flash.now[:alert] = 'Comment was not created!' } # returns status OK
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def decide_commentable
    if params[:comment_id]
      @commentable ||= Comment.find(params[:comment_id])
    elsif params[:post_id]
      @commentable ||= Post.find(params[:post_id])
    end
  end
end
