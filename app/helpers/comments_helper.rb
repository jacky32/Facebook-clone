module CommentsHelper
  def get_parent_post(comment)
    return comment if comment.instance_of?(::Post)

    get_parent_post(comment.commentable)
  end
end
