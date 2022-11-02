class Community < ApplicationRecord
  has_one_attached :background

  has_many :memberships, foreign_key: :community_id
  has_many :members, through: :memberships, source: :member
  belongs_to :admin, class_name: 'User'

  has_many :posts, dependent: :destroy

  validates_presence_of :admin, :name

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

  def members_count
    confirmed_members.count + 1 # +1 -> admin
  end

  def private?
    is_private
  end

  def pending_requests
    Membership.where(community_id: id, requested: true, confirmed_by_admin: false).limit(10)
  end

  def confirmed_members
    member_ids = if private?
                   Membership.where(community_id: id, requested: true,
                                    confirmed_by_admin: true).pluck(:member_id)
                 else
                   Membership.where(community_id: id, requested: true).pluck(:member_id)
                 end
    User.where(id: member_ids)
  end

  def ordered_posts
    posts.order('created_at ASC').limit(10)
  end

  def self.search(query)
    query = query.split(' ')
    answers = []
    query.each do |q|
      answers = where('lower(name) LIKE ?', "%#{q.downcase}%")
    end
    answers.uniq
  end
end
