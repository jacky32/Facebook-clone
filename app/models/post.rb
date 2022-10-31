class Post < ApplicationRecord
  include DateFormats
  belongs_to :user
  belongs_to :community
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  validates_presence_of :text, :user

  def public?
    if community
      !community.private?
    else
      true
    end
  end
end
