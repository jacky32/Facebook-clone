class UserInfo < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_one_attached :background

  validates_presence_of :user
end
