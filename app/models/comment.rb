class Comment < ApplicationRecord
  belongs_to :comment_author, foreign_key: 'comment_author_id', class_name: 'User'
  belongs_to :post
end
