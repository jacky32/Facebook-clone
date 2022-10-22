module PostsHelper
  def count_commentables(commentable)
    count = commentable.comments.count
    commentable.comments.each { |comm| count += count_commentables(comm) }
    count
  end
end
