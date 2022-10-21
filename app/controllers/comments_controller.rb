class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = Comments.all.order('created_at DESC')
  end

  def new
    decide_commentable_for_new
    @comment = Comment.new
    @post = Post.find(params[:post_id]) if params[:post_id]
  end

  def create
    decide_commentable
    @post = Post.find(params[:post_id]) if params[:post_id]
    @commented = Comment.find(params[:comment_id]) if params[:comment_id]
    # @comment = Comment.new(comment_params.merge(user: current_user, post: @post))
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def decide_commentable_for_new
    if params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
    end
  end

  def decide_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id])
    elsif params[:post_id]
      @commentable = Post.find_by_id(params[:post_id])
    end
  end
end
