class Community < ApplicationRecord
  has_one_attached :background

  has_many :memberships, foreign_key: :community_id
  has_many :members, through: :memberships, source: :member
  belongs_to :admin, class_name: 'User'

  has_many :posts, dependent: :destroy

  validates_presence_of :admin

  after_create :generate_default_avatar

  def generate_default_avatar
    random_number = (1..8).to_a.sample
    update(default_background: "default_bgs/bg#{random_number}.jpg")
  end

  def bg_image
    if background.attached?
      background
    else
      default_background
    end
  end

  def private?
    is_private
  end

  def ordered_posts
    posts.order('created_at ASC').limit(10)
  end
end
