class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  # has_many :comments, as: :commentable
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates_presence_of :first_name, :last_name

  has_many :friendships, dependent: :destroy
  has_many :friend_requests, -> { where accepted: false }, class_name: 'Friendship', foreign_key: 'friend_id'

  has_one :user_info, dependent: :destroy

  has_many :memberships, foreign_key: :member_id
  has_many :joined_communities, through: :memberships, source: :community
  has_many :created_communities, foreign_key: :admin_id, class_name: 'Community', dependent: :destroy

  after_create :build_user_info, :generate_default_avatar

  def build_user_info
    u_i = UserInfo.create(user_id: id)
    u_i.save
  end

  def generate_default_avatar
    random_number = (1..100).to_a.sample
    update(default_avatar: "default_avatars/avatar#{random_number}.png")
  end

  def friends
    sent_friendships = Friendship.where(user_id: id, accepted: true).pluck(:friend_id)
    received_friendships = Friendship.where(friend_id: id, accepted: true).pluck(:user_id)
    friend_ids = sent_friendships + received_friendships
    User.where(id: friend_ids)
  end

  def friends_with?(user:)
    friends.include?(user)
  end

  def mutual_friends(user:)
    other_friends = user.friends.pluck(:id)
    my_friends = friends.pluck(:id)
    mutual_friends = other_friends.select { |friend| my_friends.include?(friend) }

    # { |friend| friends.take(friend.id) if user.friends_with?(friend) }
    User.where(id: mutual_friends)
  end

  def send_friend_request(user_id:)
    friendships.create(friend_id: user_id) unless Friendship.exists?(id, user_id)
  end

  def friend_request_sent?(user_id:)
    Friendship.requested?(id, user_id)
  end

  def friend_request_received?(user_id:)
    Friendship.requested?(user_id, id)
  end

  def ordered_posts
    posts.order('created_at ASC').limit(10)
  end

  def friends_posts
    ids = friends.map(&:id)
    ids << id
    Post.includes(:user, :comments, :likes).order('created_at DESC').limit(10).where(user_id: ids)
  end

  def community_posts
    communities = joined_communities + created_communities
    Post.where(community: communities)
  end

  def get_profile_picture
    if user_info.avatar.attached?
      user_info.avatar
    else
      default_avatar
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.search(query)
    query = query.split(' ')
    answers = []
    query.each do |q|
      first_name = where('lower(first_name) LIKE ?', "%#{q.downcase}%").limit(6)
      last_name = where('lower(last_name) LIKE ?', "%#{q.downcase}%").limit(6)
      answers = answers + first_name + last_name
    end
    answers.uniq
  end
end
