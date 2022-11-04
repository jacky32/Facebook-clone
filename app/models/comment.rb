class Comment < ApplicationRecord
  include DateFormats
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  belongs_to :user
  validates_presence_of :text, :user
end
