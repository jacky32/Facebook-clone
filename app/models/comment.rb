class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy
  belongs_to :user
  validates_presence_of :text, :user
end
