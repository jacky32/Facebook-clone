module LikesHelper
  def liked(likeable)
    likeable.likes.find { |like| like.user_id == current_user.id }
  end

  def decide_destroy_path(likeable)
    if likeable.instance_of?(::Comment)
      comment_like_path(likeable, liked(likeable))
    else
      post_like_path(likeable, liked(likeable))
    end
  end

  def decide_create_path(likeable)
    if likeable.instance_of?(::Comment)
      comment_likes_path(likeable)
    else
      post_likes_path(likeable)
    end
  end
end
