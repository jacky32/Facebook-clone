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

  def get_profile_picture
    'avatar.svg'
  end

  def name
    "#{first_name} #{last_name}"
  end
end
