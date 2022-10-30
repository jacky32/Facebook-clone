class Community < ApplicationRecord
  has_one_attached :background

  has_many :memberships, foreign_key: :community_id
  has_many :members, through: :memberships, source: :member
  belongs_to :admin, class_name: 'User'
end
