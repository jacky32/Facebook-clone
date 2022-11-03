class UserInfo < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar, dependent: :destroy
  has_one_attached :background, dependent: :destroy

  validates_presence_of :user
  validates :avatar, size: { less_than: 1.megabyte, message: 'too large' }
  validates :background, size: { less_than: 1.megabyte, message: 'too large' }
end
